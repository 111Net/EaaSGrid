#!/bin/bash

echo "======================================"
echo " XaaSGrid Platform Startup Controller"
echo "======================================"

ROOT="/data/eaasgrid-platform"

cd "$ROOT" || exit 1


echo "[1] Cleaning old runtime"


pkill -f "next-server" 2>/dev/null
pkill -f "next dev" 2>/dev/null
pkill -f "next start" 2>/dev/null
pkill -f "npm run dev" 2>/dev/null
pkill -f "npm start" 2>/dev/null
pkill -f "node src/server.js" 2>/dev/null


sleep 5


echo "[2] Starting API"

cd "$ROOT/apps/api" || exit 1


nohup node src/server.js \
> "$ROOT/apps/api/api-runtime.log" 2>&1 &


sleep 5


echo "[3] API Health Check"

curl -s http://localhost:4000/api/v1/health

echo ""


echo "[4] Starting Dashboard"

cd "$ROOT/apps/dashboard" || exit 1


nohup npm run dev \
> "$ROOT/apps/dashboard/dashboard-runtime.log" 2>&1 &


sleep 12


echo "[5] Runtime Status"

echo ""

ps aux | grep -E "next-server|node src/server.js" | grep -v grep


echo ""

echo "[6] Port Check"

ss -tulpn | grep -E "3000|4000"


echo ""

echo "======================================"
echo " XaaSGrid Started"
echo "======================================"

echo ""
echo "Dashboard:"
echo "http://192.168.100.21:3000"

echo ""
echo "API:"
echo "http://192.168.100.21:4000"
