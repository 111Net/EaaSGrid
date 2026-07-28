#!/bin/bash

echo "Stopping XaaSGrid..."

pkill -f "next-server" 2>/dev/null
pkill -f "next dev" 2>/dev/null
pkill -f "next start" 2>/dev/null
pkill -f "node src/server.js" 2>/dev/null

echo "All XaaSGrid processes stopped"
