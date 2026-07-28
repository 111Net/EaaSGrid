#!/bin/bash

echo "======================================"
echo " XaaSGrid Platform Startup Controller"
echo "======================================"

ROOT="/data/eaasgrid-platform"

cd $ROOT || exit 1


echo "[1] Stopping old runtime"

pkill -f "next-server" 2>/dev/null
pkill -f "next dev" 2>/dev/null
pkill -f "next start" 2>/dev/null
pkill -f "node src/server.js" 2>/dev/null


sleep 5


echo "[2] Cleaning dashboard cache"

rm -rf apps/dashboard/.next


echo "[3] Starting API"

cd apps/api

nohup npm start > api-runtime.log 2>&1 &


sleep 5


echo "[4] Testing API"

curl -s http://localhost:4000/api/v1/health

echo ""


echo "[5] Starting Dashboard"

cd ../dashboard

nohup npm run dev > dashboard-runtime.log 2>&1 &


sleep 10


echo "[6] Checking processes"

echo ""

ps aux | grep -E "next|node src/server" | grep -v grep


echo ""

echo "======================================"
echo " XaaSGrid Started Successfully"
echo "======================================"

echo ""
echo "Dashboard:"
echo "http://192.168.100.21:3000"

echo ""
echo "API:"
echo "http://192.168.100.21:4000"
