#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform
DASH=$ROOT/apps/dashboard

echo "======================================"
echo "EAASGrid Dashboard Login Repair v2"
echo "======================================"

cd $DASH


echo "[1] Verify auth endpoint"

sed -i \
's#/api/auth/login#/api/v1/auth/login#g' \
lib/auth.js


echo "[2] Show current endpoint"

grep "login" lib/auth.js


echo "[3] Find login form implementation"

grep -R "login(" -n app src components --exclude-dir=.next || true


echo "[4] Stop all dashboard processes"

pkill -f "next dev" || true


sleep 3


echo "[5] Remove Next cache"

rm -rf .next


echo "[6] Start dashboard on port 3000"

nohup npm run dev -- --port 3000 > dashboard.log 2>&1 &


sleep 10


echo "[7] Check dashboard"

ss -tulpn | grep 3000 || true


echo
echo "======================================"
echo "LOGIN REPAIR COMPLETE"
echo "======================================"
