#!/bin/bash

set -eo pipefail

VERSION=2.1.1

NAME="quay.io/desource/docker-registry:$VERSION"
docker build -t $NAME .

echo "Built '$NAME'"
