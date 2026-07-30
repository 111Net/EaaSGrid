#!/bin/bash

set -e

echo "======================================"
echo " EaaSGrid Dashboard Pilot Repair"
echo " $(date)"
echo "======================================"

BASE=/data/eaasgrid-platform
API=$BASE/apps/api
DASH=$BASE/apps/dashboard


echo "[1] Checking PostgreSQL data..."

sudo -u postgres psql -d eaas_db <<EOF

SELECT current_database(), current_user;

SELECT COUNT(*) AS devices
FROM devices;

SELECT COUNT(*) AS energy_readings
FROM energy_usage;

SELECT COUNT(*) AS ledger_accounts
FROM ledger_accounts;

EOF


echo "[2] Checking API environment..."

API_PID=$(pgrep -f "node src/server.js" || true)

if [ -n "$API_PID" ]; then
    echo "API PID: $API_PID"

    cat /proc/$API_PID/environ \
    | tr '\0' '\n' \
    | grep DATABASE_URL || true

else
    echo "API process not found"
fi


echo "[3] Testing API dashboard endpoint..."

curl -s \
http://192.168.100.21:4000/api/v1/dashboard \
| jq .


echo "[4] Stopping stale API..."

pkill -f "node src/server.js" || true

sleep 3


echo "[5] Starting API..."

cd $API

nohup node src/server.js \
> /tmp/eaasgrid-api.log 2>&1 &


sleep 5


echo "[6] Testing fresh API..."

curl -s \
http://192.168.100.21:4000/api/v1/dashboard \
| jq .


echo "[7] Restarting dashboard..."

pkill -f "next start" || true

sleep 3


cd $DASH

nohup npm run start \
> /tmp/eaasgrid-dashboard.log 2>&1 &


sleep 8


echo "[8] Checking ports..."

ss -tulpn | grep -E "3000|4000" || true


echo "======================================"
echo " EaaSGrid Dashboard Repair Complete"
echo "======================================"

chmod +x scripts/dashboard-pilot-repair.sh
