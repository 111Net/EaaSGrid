#!/bin/bash

set -e

echo "XaaSGrid Ubuntu Production Bootstrap"


apt update

apt install -y \
curl \
git \
ufw \
nginx \
certbot \
docker.io \
docker-compose-plugin


systemctl enable docker

systemctl start docker


echo "Docker ready"

