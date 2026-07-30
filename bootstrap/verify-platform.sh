#!/bin/bash

echo "XaaSGrid Platform Verification"

echo "Node:"
node -v

echo "NPM:"
npm -v

echo "Docker:"
docker --version

echo "Compose:"
docker compose version

echo "Git:"
git --version

echo "Verification complete"
