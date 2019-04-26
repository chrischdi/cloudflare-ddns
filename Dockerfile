FROM scratch
COPY cloudflare-ddns /
ENTRYPOINT ["/cloudflare-ddns"]
