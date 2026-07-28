#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform
DASHBOARD=$ROOT/apps/dashboard

echo "======================================"
echo "EAASGrid Dashboard Auth Integration Fix"
echo "======================================"

cd $DASHBOARD


echo "[1] Backup auth.js"

cp lib/auth.js lib/auth.js.backup.$(date +%F-%H%M)


echo "[2] Fixing API login endpoint"

sed -i \
's#/api/auth/login#/api/v1/auth/login#g' \
lib/auth.js


echo "[3] Clearing Next cache"

rm -rf .next


echo "[4] Restarting dashboard processes"

pkill -f "next dev" || true


echo "[5] Starting dashboard"

nohup npm run dev > dashboard.log 2>&1 &


sleep 8


echo "[6] Checking ports"

ss -tulpn | grep 3000 || true
ss -tulpn | grep 3001 || true


echo
echo "======================================"
echo "Dashboard Auth Fix Completed"
echo "======================================"

echo "Test:"
echo "http://192.168.100.21:3000/login"
