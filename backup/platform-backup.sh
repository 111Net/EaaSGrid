#!/bin/bash

set -e


DATE=$(date +%Y%m%d-%H%M)

mkdir -p backups


tar -czf backups/xaasgrid-platform-$DATE.tar.gz \
apps \
packages \
database \
deployment \
config \
scripts \
backup


echo "Platform backup created"

