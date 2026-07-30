#!/bin/bash

set -e

echo "XaaSGrid Production Deployment"

docker compose up -d

echo "Deployment complete"

