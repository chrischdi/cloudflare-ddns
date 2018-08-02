# cloudflare-ddns
[![Build Status](https://travis-ci.org/chrischdi/cloudflare-ddns.svg?branch=master)](https://travis-ci.org/chrischdi/cloudflare-ddns)

`cloudflare-ddns` is a client to dynamically update dns records on cloudflare.

On its first start it will fetch the current set IP address of the passed dns record and will compare it to the current real public ip address. 

```
$ cloudflare-ddns -h
Usage of ./cloudflare-ddns:
  -public-ip-url string
    	URL to fetch the current public ip address (default "https://checkip.amazonaws.com/")
  -record-name string
    	name of the dns record to update
  -refresh-interval int
    	Interval in seconds between record updates (default 300s) (default 300)
  -zone-name string
    	name of the dns zone
```

# Install from source

Install or update from current master:

```
go get -u github.com/chrischdi/cloudflare-ddns
```

# Usage

To use `cloudflare-ddns` you have to set the following Cloudflare credentials by environment variables:
* `CF_API_EMAIL`: your login e-mail address
* `CF_API_KEY`: your Cloudflare API key
Additionaly the following cli parameters are mandatory:
* `-record-name`
* `-zone-name`

# Contribute

Feel free to clone or fork this repo to start contributing.