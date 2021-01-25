package main

import (
	"flag"
	"fmt"
	"io/ioutil"
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

	if *dnsName == "" {
		log.Fatalf("error: record-name parameter is mandatory")
	}

	if *once {
		api, zoneID, recordV4, recordV6, err := initialize()
		if err != nil {
			log.Fatalf("error on initialize: %v", err)
		}

		if err := updateIPv4(api, zoneID, recordV4); err != nil {
			log.Fatalf("error on update: %v", err)
		}

		if err := updateIPv6(api, zoneID, recordV6); err != nil {
			log.Fatalf("error on update: %v", err)
		}
		return
	}

	backoff = exponentialBackoffSleep{
		*maxBackoff,
		time.Second,
	}

	var err error
	for {
		err = run()
		if err != nil {
			log.Printf("error: %v", err)
			backoff.Sleep()
		}
	}
}

func run() error {
	api, zoneID, recordV4, recordV6, err := initialize()
	if err != nil {
		return err
	}

	for {
		if err := updateIPv4(api, zoneID, recordV4); err != nil {
			return err
		}
		if err := updateIPv6(api, zoneID, recordV6); err != nil {
			return err
		}
		backoff.Reset()
		time.Sleep(time.Second * time.Duration(*refreshInterval))
	}
}

func initialize() (*cloudflare.API, string, *cloudflare.DNSRecord, *cloudflare.DNSRecord, error) {
	log.Println("creating cloudflare api object")
	// Construct a new API object
	api, err := cloudflare.New(*cfAPIKey, *cfAPIEMail)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("getting zone id by name %s", *zoneName)
	zoneID, err := api.ZoneIDByName(*zoneName)
	if err != nil {
		return nil, "", nil, nil, fmt.Errorf("error getting dns zone id by name: %v", err)
	}

	log.Printf("getting A dns record for name %s", *dnsName)
	records, err := api.DNSRecords(zoneID, cloudflare.DNSRecord{Name: *dnsName})
	if err != nil {
		return nil, "", nil, nil, fmt.Errorf("error getting dns record: %v", err)
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
		return nil, "", nil, nil, fmt.Errorf("error getting dns record: expected to at least have either a A or AAAA record")
	}

	return api, zoneID, recordV4, recordV6, nil
}

func updateIPv6(api *cloudflare.API, zoneID string, record *cloudflare.DNSRecord) error {
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
	return updateRecord(api, zoneID, public, *record)
}

func updateIPv4(api *cloudflare.API, zoneID string, record *cloudflare.DNSRecord) error {
	if record == nil {
		log.Printf("not updating IPv4 - no record found in cloudflare")
		return nil
	}
	public, err := getPublicIPv4()
	if err != nil {
		return fmt.Errorf("error getting public ip: %v", err)
	}
	return updateRecord(api, zoneID, public, *record)
}

func updateRecord(api *cloudflare.API, zoneID, public string, record cloudflare.DNSRecord) error {
	if public != record.Content {
		err := api.UpdateDNSRecord(zoneID, record.ID, cloudflare.DNSRecord{
			Content: public,
		})
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
	defer resp.Body.Close()

	ip, err := ioutil.ReadAll(resp.Body)
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
