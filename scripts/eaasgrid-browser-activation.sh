#!/usr/bin/env bash

set -e

ROOT="/data/eaasgrid-platform"

echo "======================================="
echo " EaaSGrid Browser Activation"
echo "======================================="

echo
echo "[1] Detecting platform IP"

IP=$(hostname -I | awk '{print $1}')

echo "Detected IP:"
echo $IP


echo
echo "[2] Checking PostgreSQL"

systemctl status postgresql --no-pager >/dev/null

echo "PostgreSQL: OK"


echo
echo "[3] Checking API"

API_STATUS=$(curl -s \
http://$IP:4000/api/v1/health)

echo $API_STATUS


echo
echo "[4] Checking Dashboard"

if lsof -i :3000 >/dev/null
then
 echo "Port 3000 occupied"
else
 echo "Port 3000 available"
fi


echo
echo "[5] Stopping old Next processes"

pkill -f "next dev" || true


echo
echo "[6] Starting Dashboard"

cd $ROOT/apps/dashboard

nohup npm run dev \
> /tmp/eaasgrid-dashboard.log 2>&1 &


echo
echo "[7] Waiting"

sleep 10


echo
echo "======================================="
echo " BROWSER ACCESS"
echo "=======================================

echo
echo "Dashboard
echo "http://$IP:3000"

echo
echo "API:"
echo "http://$IP:4000"

echo
echo "Health:"
echo "http://$IP:4000/api/v1/health"

echo
echo "======================================="
echo " COMPLETE"
echo "======================================="
