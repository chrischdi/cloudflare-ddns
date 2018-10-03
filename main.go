package main

import (
	"flag"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/cloudflare/cloudflare-go"
)

var (
	zoneName        = flag.String("zone-name", "", "name of the dns zone")
	dnsName         = flag.String("record-name", "", "name of the dns record to update")
	refreshInterval = flag.Int64("refresh-interval", 300, "Interval in seconds between record updates (default 300s)")
	publicIPURL     = flag.String("public-ip-url", "https://checkip.amazonaws.com/", "URL to fetch the current public ip address")
)

func main() {
	flag.Parse()

	if *dnsName == "" {
		log.Fatalf("error: record-name parameter is mandatory")
	}

	log.Println("creating cloudflare api object")
	// Construct a new API object
	api, err := cloudflare.New(os.Getenv("CF_API_KEY"), os.Getenv("CF_API_EMAIL"))
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("getting zone id by name %s", *zoneName)
	zoneID, err := api.ZoneIDByName(*zoneName)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("getting A dns record for name %s", *dnsName)
	records, err := api.DNSRecords(zoneID, cloudflare.DNSRecord{Type: "A", Name: *dnsName})

	if len(records) != 1 {
		log.Fatalf("error: dns record not found")
	}

	record := records[0]

	var public string

	for {
		public, err = getPublicIP()
		public = strings.TrimSuffix(public, "\n")
		if public != record.Content {
			record.Content = public
			err = api.UpdateDNSRecord(zoneID, record.ID, cloudflare.DNSRecord{
				Content: public,
			})
			if err != nil {
				log.Printf("error updating dns record to %s: %v", public, err)
			} else {
				log.Printf("successfully updated ip from to %s", public)
			}
		} else {
			log.Printf("no update needed")
		}
		time.Sleep(time.Second * time.Duration(*refreshInterval))
	}
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
