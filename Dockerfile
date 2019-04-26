FROM gcr.io/distroless/static
COPY cloudflare-ddns /
ENTRYPOINT ["/cloudflare-ddns"]
