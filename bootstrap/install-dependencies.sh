#!/bin/bash

set -e

echo "XaaSGrid dependency installer"

sudo apt update

sudo apt install -y \
git \
curl \
docker.io \
docker-compose-plugin \
postgresql-client

echo "Dependencies installed"
