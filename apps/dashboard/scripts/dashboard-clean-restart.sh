#!/bin/bash

echo "======================================"
echo " XaaSGrid Dashboard Clean Restart"
echo "======================================"

APP_DIR="/data/eaasgrid-platform/apps/dashboard"

cd $APP_DIR || exit 1


echo "[1] Stopping all Next processes"

pkill -f "next dev" 2>/dev/null
pkill -f "next start" 2>/dev/null
pkill -f "next-server" 2>/dev/null


sleep 3


echo "[2] Removing stale cache"

rm -rf .next


echo "[3] Checking ports"

PORTS=$(lsof -ti:3000)

if [ ! -z "$PORTS" ]; then
    kill -9 $PORTS
fi


PORTS=$(lsof -ti:3003)

if [ ! -z "$PORTS" ]; then
    kill -9 $PORTS
fi


echo "[4] Running validation"

npm run lint


echo "[5] Starting XaaSGrid Dashboard"

npm run dev
