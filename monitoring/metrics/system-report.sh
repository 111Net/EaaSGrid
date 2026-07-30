#!/bin/bash

echo "XaaSGrid System Metrics"

echo

echo "Hostname:"
hostname

echo

echo "Memory:"
free -h

echo

echo "Disk:"
df -h /

echo

echo "Docker:"
docker ps

