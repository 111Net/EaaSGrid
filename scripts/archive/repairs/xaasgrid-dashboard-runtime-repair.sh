#!/bin/bash

BASE=/data/eaasgrid-platform

echo "=========================================="
echo " XaaSGrid Dashboard Runtime Repair"
echo " Turbopack Cache + Session Recovery"
echo "=========================================="


cd $BASE


echo "[1] Stopping dashboard processes"

pkill -f "next dev" || true

sleep 3


echo "[2] Clearing corrupted Next cache"

rm -rf apps/dashboard/.next


echo "[3] Clearing Turbopack cache"

rm -rf apps/dashboard/node_modules/.cache

rm -rf apps/dashboard/.turbo


echo "[4] Verifying permission export"

grep -n "getCurrentUser" \
apps/dashboard/lib/permissions.js


echo "[5] Rebuilding dashboard"


cd apps/dashboard

npm run build


echo "[6] Starting dashboard"


nohup npm run dev \
> dashboard-runtime.log 2>&1 &


sleep 10


echo "[7] Dashboard health"

curl -I http://localhost:3000/login


echo "=========================================="
echo " DASHBOARD RUNTIME REPAIR COMPLETE"
echo "=========================================="
