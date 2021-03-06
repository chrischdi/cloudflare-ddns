# cloudflare-ddns
![Build Status](https://github.com/chrischdi/cloudflare-ddns/workflows/.github/workflows/ci.yml/badge.svg)

`cloudflare-ddns` is a client to dynamically update dns records on cloudflare.

On its first start it will fetch the current set IP address of the passed dns record and will compare it to the current real public ip address. 

```
$ ./cloudflare-ddns -h
Usage of ./cloudflare-ddns:
  -cf-api-email CF_API_EMAIL
        cloudflare account e-mail address (env CF_API_EMAIL)
  -cf-api-key CF_API_KEY
        cloudflare api key (env CF_API_KEY)
  -max-backoff duration
        maximum value for exponential backoff (default 30m0s)
  -once
        only update once and exit
  -public-ip-url string
        URI to fetch the current public ip address (default "https://checkip.amazonaws.com/")
  -record-name DNS_RECORD_NAME
        name of the dns record to update (env DNS_RECORD_NAME)
  -refresh-interval int
        Interval in seconds between record updates (default 300s) (default 300)
  -zone-name DNS_ZONE_NAME
        name of the dns zone (env DNS_ZONE_NAME)
```

# Install from source

Install or update from current master:

```
go get -u github.com/chrischdi/cloudflare-ddns
```

# Usage

To use `cloudflare-ddns` you have to set the following flags either directly or via 
environment variables:
* `-cf-api-email`
* `-cf-api-key`
* `-record-name DNS_RECORD_NAME`
* `-refresh-interval int`

# Contribute

Feel free to clone or fork this repo to start contributing.