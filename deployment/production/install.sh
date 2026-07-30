#!/bin/bash

set -e

echo "XaaSGrid VPS Installer"

sudo apt update

sudo apt install -y \
git \
curl \
docker.io \
docker-compose-plugin \
nginx

sudo systemctl enable docker

echo "Dependencies installed"

