#!/bin/bash

VERSION=2.1.1

ACTOOL=${ACTOOL:-actool}
IMAGEDIR=${IMAGEDIR:-build/image}

mkdir -p ${IMAGEDIR}/rootfs

mkdir -p ${IMAGEDIR}/rootfs/etc/
cat <<EOF > ${IMAGEDIR}/rootfs/etc/hosts
127.0.0.1   localhost localhost.localdomain
EOF

cp build/registry ${IMAGEDIR}/rootfs/

cp config.yml ${IMAGEDIR}/rootfs/

cat <<EOF > ${IMAGEDIR}/manifest
{
  "acKind": "ImageManifest",
  "acVersion": "0.5.1",
  "name": "markus/docker-registry",
  "labels": [
    { "name": "os",      "value": "linux" },
    { "name": "arch",    "value": "amd64" },
    { "name": "version", "value": "${VERSION}" }
  ],
  "app": {
    "environment": [],
    "user": "0",
    "group": "0",
    "exec": [ "/registry", "/config.yml" ],
    "mountPoints": [
      { "name": "data", "path": "/data" }
    ],
    "ports": [
      { "name": "registry-api", "port": 5000, "protocol": "tcp" }
    ]
  }
}
EOF

NAME="docker-registry-${VERSION}-linux-amd64.aci"
$ACTOOL build -overwrite=true ${IMAGEDIR} ${NAME}

echo "Built '$NAME'"
