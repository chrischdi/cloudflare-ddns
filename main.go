package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
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
	publicIPURL     = flag.String("public-ip-url", "https://checkip.amazonaws.com/", "URI to fetch the current public ip address")
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
		api, zoneID, record, err := initialize()
		if err != nil {
			log.Fatalf("error on initialize: %v", err)
		}

		if err := update(api, zoneID, record); err != nil {
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
	api, zoneID, record, err := initialize()
	if err != nil {
		return err
	}

	for {
		if err := update(api, zoneID, record); err != nil {
			return err
		}
		backoff.Reset()
		time.Sleep(time.Second * time.Duration(*refreshInterval))
	}
}

func initialize() (api *cloudflare.API, zoneID string, record cloudflare.DNSRecord, err error) {
	log.Println("creating cloudflare api object")
	// Construct a new API object
	api, err = cloudflare.New(*cfAPIKey, *cfAPIEMail)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("getting zone id by name %s", *zoneName)
	zoneID, err = api.ZoneIDByName(*zoneName)
	if err != nil {
		err = fmt.Errorf("error getting dns record: %v", err)
		return
	}

	log.Printf("getting A dns record for name %s", *dnsName)
	records, err := api.DNSRecords(zoneID, cloudflare.DNSRecord{Type: "A", Name: *dnsName})
	if err != nil {
		err = fmt.Errorf("error getting dns record: %v", err)
		return
	}
	if len(records) != 1 {
		err = fmt.Errorf("error getting dns record: %v", err)
		return
	}

	record = records[0]
	return
}

func update(api *cloudflare.API, zoneID string, record cloudflare.DNSRecord) error {
	public, err := getPublicIP()
	if err != nil {
		return fmt.Errorf("error getting public ip: %v", err)
	}
	public = strings.TrimSuffix(public, "\n")
	if public != record.Content {
		record.Content = public
		err = api.UpdateDNSRecord(zoneID, record.ID, cloudflare.DNSRecord{
			Content: public,
		})
		if err != nil {
			return fmt.Errorf("error updating dns record to %s: %v", public, err)
		} else {
			log.Printf("successfully updated ip from to %s", public)
		}
	} else {
		log.Printf("no update needed")
	}
	return nil
}

// getPublicIP returns the internet facing public ip address
func getPublicIP() (string, error) {
	resp, err := http.Get(*publicIPURL)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	ip, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(ip), nil
}
