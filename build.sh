#!/usr/bin/env bash

set -e

platforms="linux/amd64 linux/arm linux/arm64"

name="cloudflare-ddns"

mkdir -p bin tar

for platform in ${platforms}
do
  split=(${platform//\// })
  goos=${split[0]}
  goarch=${split[1]}

  # prepare
  ext=""
  if [ "$goos" == "windows" ]; then
    ext=".exe"
  fi
  mkdir -p bin/$goos/$goarch

  # build
  CGO_ENABLED=0 GOOS=$goos GOARCH=$goarch go build -ldflags='-s -w' -o bin/$goos/$goarch/$name$ext
  
  # pack
  tar cfvz tar/$name-$goos-$goarch.tar.gz -C bin/$goos/$goarch .
done
