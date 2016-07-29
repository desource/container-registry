#!/bin/bash

VERSION=2.1.1

function clean() {
    rm -rf build;
}

function build_registry() {

    cat <<EOF | docker build --pull -t "docker-registry-build" -
FROM golang:1.5-wheezy
RUN \
  mkdir -p /go/src/github.com/docker/distribution && \
  curl -sL https://github.com/docker/distribution/archive/v$VERSION.tar.gz | \
  tar xz -C src/github.com/docker/distribution --strip-components 1 && \
  sed -i 's/var Version = .*$/var Version = "v$VERSION"/' src/github.com/docker/distribution/version/version.go && \
  export GOPATH=/go/src/github.com/docker/distribution/Godeps/_workspace/:/go && \
  CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-extldflags "-static" -s' -o /go/bin/registry src/github.com/docker/distribution/cmd/registry/main.go
EOF

    ID=`docker inspect -f '{{ .Id }}' docker-registry-build`

    mkdir -p bin

    docker save $ID | \
        tar -xOf - "$ID/layer.tar" | \
        tar -xf - -C bin --strip-components=2 go/bin/registry
}

clean

build_registry
