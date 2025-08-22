package main

import (
	"context"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/cloudflare/cloudflare-go"
)

var (
	zoneName        = flag.String("zone-name", os.Getenv("DNS_ZONE_NAME"), "name of the dns zone (env `DNS_ZONE_NAME`)")
	dnsName         = flag.String("record-name", os.Getenv("DNS_RECORD_NAME"), "name of the dns record to update (env `DNS_RECORD_NAME`)")
	dnsNames        = flag.String("record-names", os.Getenv("DNS_RECORD_NAMES"), "comma separated list of of the dns records to update (env `DNS_RECORD_NAMES`)")
	cfAPIKey        = flag.String("cf-api-key", os.Getenv("CF_API_KEY"), "cloudflare api key (env `CF_API_KEY`)")
	cfAPIEMail      = flag.String("cf-api-email", os.Getenv("CF_API_EMAIL"), "cloudflare account e-mail address (env `CF_API_EMAIL`)")
	refreshInterval = flag.Int64("refresh-interval", 300, "Interval in seconds between record updates (default 300s)")
	publicIPURL     = flag.String("public-ip-url", "https://checkip.amazonaws.com/", "URI to fetch the current public ipv4 address")
	interfaceName   = flag.String("interface-name", os.Getenv("INTERFACE_NAME"), "Network interface name to detect public IPv6 address")
	maxBackoff      = flag.Duration("max-backoff", time.Minute*30, "maximum value for exponential backoff")
	once            = flag.Bool("once", false, "only update once and exit")
	backoff         exponentialBackoffSleep
)

type exponentialBackoffSleep struct {
	maximum time.Duration
	current time.Duration
}

func (e *exponentialBackoffSleep) Reset() {
	e.current = time.Second
}

func (e *exponentialBackoffSleep) Sleep() {
	log.Printf("backoffsleep: (current=%s, max=%s)", backoff.current, backoff.maximum)
	time.Sleep(e.current)
	e.current = e.current * 2
	if e.current > e.maximum {
		e.current = e.maximum
	}
}

func main() {
	flag.Parse()

	if *dnsName == "" && *dnsNames == "" {
		log.Fatalf("error: record-name parameter is mandatory")
	}

	allDNSNames := strings.Split(*dnsNames, ",")
	if *dnsName != "" {
		allDNSNames = append(allDNSNames, *dnsName)
	}

	ctx := context.Background()

	if *once {
		api, zoneID, err := initialize()
		if err != nil {
			log.Fatalf("error on initialize: %v", err)
		}
		for _, dnsName := range allDNSNames {
			if err := runOnce(ctx, api, zoneID, dnsName); err != nil {
				log.Fatalf("error updating record for %s: %v", dnsName, err)
			} else {
				log.Printf("successfully updated record %s", dnsName)
			}
		}
		return
	}

	backoff = exponentialBackoffSleep{
		*maxBackoff,
		time.Second,
	}

	var err error
	for {
		err = run(allDNSNames)
		if err != nil {
			log.Printf("error: %v", err)
			backoff.Sleep()
		}
	}
}

func run(dnsNames []string) error {
	api, zoneID, err := initialize()
	if err != nil {
		return err
	}

	for {
		ctx := context.Background()
		for _, dnsName := range dnsNames {
			if err := runOnce(ctx, api, zoneID, dnsName); err != nil {
				return err
			}
		}
		backoff.Reset()
		time.Sleep(time.Second * time.Duration(*refreshInterval))
	}
}

func runOnce(ctx context.Context, api *cloudflare.API, zoneID, dnsName string) error {
	recordV4, recordV6, err := getRecords(ctx, api, zoneID, dnsName)
	if err != nil {
		log.Fatalf("error on getRecords: %v", err)
	}
	if err := updateIPv4(ctx, api, zoneID, recordV4); err != nil {
		return err
	}
	if err := updateIPv6(ctx, api, zoneID, recordV6); err != nil {
		return err
	}
	return nil
}

func initialize() (*cloudflare.API, string, error) {
	log.Println("creating cloudflare api object")
	// Construct a new API object
	api, err := cloudflare.New(*cfAPIKey, *cfAPIEMail)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("getting zone id by name %s", *zoneName)
	zoneID, err := api.ZoneIDByName(*zoneName)
	if err != nil {
		return nil, "", fmt.Errorf("error getting dns zone id by name: %v", err)
	}

	return api, zoneID, nil
}

func getRecords(ctx context.Context, api *cloudflare.API, zoneID, dnsName string) (*cloudflare.DNSRecord, *cloudflare.DNSRecord, error) {
	log.Printf("getting dns records for name %s", dnsName)
	records, _, err := api.ListDNSRecords(ctx, cloudflare.ZoneIdentifier(zoneID), cloudflare.ListDNSRecordsParams{Name: dnsName})
	if err != nil {
		return nil, nil, fmt.Errorf("error getting dns record: %v", err)
	}

	var recordV4 *cloudflare.DNSRecord
	var recordV6 *cloudflare.DNSRecord
	for _, record := range records {
		if record.Type == "A" {
			r := record
			recordV4 = &r
		}
		if record.Type == "AAAA" {
			r := record
			recordV6 = &r
		}
	}

	if recordV4 == nil && recordV6 == nil {
		return nil, nil, fmt.Errorf("error getting dns record: expected to at least have either a A or AAAA record")
	}

	return recordV4, recordV6, nil
}

func updateIPv6(ctx context.Context, api *cloudflare.API, zoneID string, record *cloudflare.DNSRecord) error {
	// don't update if no device is given
	if *interfaceName == "" {
		return nil
	}
	if record == nil {
		log.Printf("not updating IPv6 - no record found in cloudflare")
		return nil
	}
	public, err := getPublicIPv6()
	if err != nil {
		return fmt.Errorf("error getting public ip: %v", err)
	}
	return updateRecord(ctx, api, zoneID, public, *record)
}

func updateIPv4(ctx context.Context, api *cloudflare.API, zoneID string, record *cloudflare.DNSRecord) error {
	if record == nil {
		log.Printf("not updating IPv4 - no record found in cloudflare")
		return nil
	}
	public, err := getPublicIPv4()
	if err != nil {
		return fmt.Errorf("error getting public ip: %v", err)
	}
	return updateRecord(ctx, api, zoneID, public, *record)
}

func updateRecord(ctx context.Context, api *cloudflare.API, zoneID, public string, record cloudflare.DNSRecord) error {
	if public != record.Content {
		_, err := api.UpdateDNSRecord(ctx, cloudflare.ZoneIdentifier(zoneID), cloudflare.UpdateDNSRecordParams{Content: public})
		if err != nil {
			return fmt.Errorf("error updating dns record from %s to %s: %v", record.Content, public, err)
		}
		log.Printf("successfully updated ip from %s to %s", record.Content, public)
	} else {
		log.Printf("no update needed")
	}
	return nil
}

// getPublicIPv6 returns the internet facing public IPv6 address
func getPublicIPv6() (string, error) {
	iface, err := net.InterfaceByName(*interfaceName)
	if err != nil {
		return "", err
	}
	addrs, err := iface.Addrs()
	if err != nil {
		return "", err
	}
	_ = addrs
	for _, a := range addrs {
		ip, _, err := net.ParseCIDR(a.String())
		if err != nil {
			return "", err
		}
		if mightBePublic(ip) {
			return ip.String(), nil
		}
	}
	return "", fmt.Errorf("public ipv6 addr was not found")
}

// getPublicIPv4 returns the internet facing public IPv4 address
func getPublicIPv4() (string, error) {
	resp, err := http.Get(*publicIPURL)
	if err != nil {
		return "", err
	}
	defer func() { _ = resp.Body.Close() }()

	ip, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return strings.TrimSuffix(string(ip), "\n"), nil
}

var disallowedCIDRs = []string{"0.0.0.0/0", "fd00::/8", "fe80::/64", "127.0.0.0/8", "::1/128"}

func mightBePublic(ip net.IP) bool {
	for _, cidr := range disallowedCIDRs {
		_, subnet, err := net.ParseCIDR(cidr)
		if err != nil {
			panic("failed to parse hardcoded loopback cidr: " + err.Error())
		}
		if subnet.Contains(ip) {
			return false
		}
	}
	return true
}
