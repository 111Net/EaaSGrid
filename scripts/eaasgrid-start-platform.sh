#!/usr/bin/env bash

set -e

ROOT="/data/eaasgrid-platform"
IP=$(hostname -I | awk '{print $1}')

echo "======================================"
echo " EaaSGrid Platform Startup"
echo "======================================"

echo
echo "Detected IP:"
echo $IP


echo
echo "[1] Checking PostgreSQL"

systemctl is-active postgresql >/dev/null

echo "PostgreSQL: RUNNING"


echo
echo "[2] Starting API"

cd $ROOT/apps/api

pkill -f "node src/server.js" || true

nohup npm run dev > /tmp/eaasgrid-api.log 2>&1 &


echo
echo "Waiting for API..."
sleep 5


echo
echo "[3] API Health"

curl -s http://$IP:4000/api/v1/health


echo
echo
echo "[4] Starting Dashboard"

cd $ROOT/apps/dashboard

pkill -f "next dev" || true

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo
echo "Waiting for GUI..."
sleep 10


echo
echo "======================================"
echo " EaaSGrid READY"
echo "======================================"

echo
echo "Browser:"
echo "http://$IP:3000"

echo
echo "API:"
echo "http://$IP:4000"

echo 
echo "Health:"
echo "http://$IP:4000/api/v1/health"

echo
echo "Dashboard API:"
echo "http://$IP:4000/api/v1/dashboard"

echo
echo "======================================"





















