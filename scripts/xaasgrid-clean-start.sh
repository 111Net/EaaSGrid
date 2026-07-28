#!/bin/bash

echo "======================================"
echo " XaaSGrid Clean Startup Controller"
echo "======================================"

ROOT="/data/eaasgrid-platform"


echo "[1] Stop old Next processes"

pkill -f "next dev" 2>/dev/null
pkill -f "next start" 2>/dev/null


echo "[2] Stop old Node API"

pkill -f "apps/api" 2>/dev/null
pkill -f "server.js" 2>/dev/null


echo "[3] Clean dashboard cache"

cd $ROOT/apps/dashboard

rm -rf .next


echo "[4] Check ports"

echo "Port 3000"
lsof -i :3000 || true

echo "Port 3003"
lsof -i :3003 || true

echo "Port 4000"
lsof -i :4000 || true


echo "[5] Start API"

cd $ROOT/apps/api

nohup npm run start \
> api-runtime.log 2>&1 &


sleep 5


echo "[6] Start Dashboard"

cd $ROOT/apps/dashboard

nohup npm run dev \
> dashboard-runtime.log 2>&1 &


sleep 8


echo "[7] Health checks"


echo "API:"
curl -s http://localhost:4000/api/v1/health


echo ""
echo ""

echo "Dashboard:"
curl -I http://localhost:3000 || curl -I http://localhost:3003


echo ""
echo "======================================"
echo " XaaSGrid Startup Complete"
echo "======================================"
