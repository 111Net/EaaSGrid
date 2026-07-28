#!/bin/bash

echo "======================================"
echo " XaaSGrid Clean Start Controller"
echo "======================================"

ROOT="/data/eaasgrid-platform"

cd $ROOT || exit 1


echo "[1] Stopping old Node processes"

pkill -9 -f "next-server" 2>/dev/null
pkill -9 -f "next start" 2>/dev/null
pkill -9 -f "next dev" 2>/dev/null
pkill -9 -f "node src/server.js" 2>/dev/null


sleep 3


echo "[2] Checking remaining Node processes"

ps aux | grep -E "next|node" | grep -v grep || true


echo "[3] Cleaning dashboard cache"

rm -rf apps/dashboard/.next


echo "[4] Starting API"

cd apps/api

nohup npm start > api-runtime.log 2>&1 &

sleep 5


echo "[5] Starting Dashboard"

cd ../dashboard

nohup npm run dev > dashboard-runtime.log 2>&1 &


sleep 8


echo "[6] Runtime status"

echo ""
echo "API:"
curl -s http://localhost:4000/api/v1/health || echo "API not responding"


echo ""
echo ""
echo "Dashboard processes"

ps aux | grep next | grep -v grep || true


echo ""
echo "======================================"
echo " XaaSGrid Clean Start Complete"
echo "======================================"

echo ""
echo "Dashboard:"
echo "http://192.168.100.21:3000"

echo "API:"
echo "http://192.168.100.21:4000"
