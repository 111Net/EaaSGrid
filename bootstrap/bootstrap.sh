#!/bin/bash

set -e

echo "======================================"
echo " XaaSGrid Bootstrap"
echo "======================================"

echo "Checking operating system"

grep Ubuntu /etc/os-release || true

echo "Checking Git"

git --version

echo "Checking Node"

node -v

echo "Checking Docker"

docker --version

echo "Checking Docker Compose"

docker compose version

echo "Bootstrap validation complete"
