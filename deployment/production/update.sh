#!/bin/bash

set -e

echo "Updating XaaSGrid"

git pull

docker compose build

docker compose up -d

echo "Update complete"

