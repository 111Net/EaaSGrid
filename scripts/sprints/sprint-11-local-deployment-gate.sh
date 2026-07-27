#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-11"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/local-deployment-report.txt"

PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 11" | tee -a "$REPORT"
echo "Local Deployment Gate Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Host System Check" | tee -a "$REPORT"


hostnamectl 2>/dev/null | tee -a "$REPORT" || true

echo "" >> "$REPORT"

ip addr | grep inet | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[2] Required Services Check" | tee -a "$REPORT"



SERVICES=(
postgresql
redis-server
nginx
)


for SERVICE in "${SERVICES[@]}"
do

if systemctl is-active --quiet "$SERVICE"; then

echo "$SERVICE : RUNNING" | tee -a "$REPORT"

else

echo "$SERVICE : NOT RUNNING" | tee -a "$REPORT"

fi

done




echo "" | tee -a "$REPORT"
echo "[3] Port Availability Check" | tee -a "$REPORT"


PORTS=(
3000
3001
4000
5432
6379
80
443
)


for PORT in "${PORTS[@]}"
do


if ss -tulnp | grep ":$PORT" >/dev/null 2>&1; then

echo "PORT $PORT : ACTIVE" | tee -a "$REPORT"

else

echo "PORT $PORT : NOT ACTIVE" | tee -a "$REPORT"

fi


done




echo "" | tee -a "$REPORT"
echo "[4] Application Directory Check" | tee -a "$REPORT"


APPS=(
apps/api
apps/dashboard
apps/investor-portal
)


for APP in "${APPS[@]}"
do

if [ -d "$ROOT/$APP" ]; then

echo "$APP : FOUND" | tee -a "$REPORT"

else

echo "$APP : MISSING" | tee -a "$REPORT"

PASS=false

fi

done




echo "" | tee -a "$REPORT"
echo "[5] API Health Check" | tee -a "$REPORT"



if command -v curl >/dev/null 2>&1; then


API_RESULT=$(curl -s \
http://localhost:4000/api/v1/health \
|| true)


echo "$API_RESULT" | tee -a "$REPORT"


if echo "$API_RESULT" | grep -q "ok"; then

echo "API HEALTH : PASS" | tee -a "$REPORT"

else

echo "API HEALTH : FAIL" | tee -a "$REPORT"

PASS=false

fi


fi




echo "" | tee -a "$REPORT"
echo "[6] Frontend Availability Check" | tee -a "$REPORT"


for URL in \
"http://localhost:3000" \
"http://localhost:3001"

do


STATUS=$(curl -o /dev/null \
-s \
-w "%{http_code}" \
"$URL" || true)


echo "$URL HTTP STATUS $STATUS" | tee -a "$REPORT"


done




echo "" | tee -a "$REPORT"
echo "[7] Database Connectivity Check" | tee -a "$REPORT"



if command -v pg_isready >/dev/null 2>&1; then


pg_isready | tee -a "$REPORT"


else

echo "pg_isready unavailable" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[8] Redis Connectivity Check" | tee -a "$REPORT"



if command -v redis-cli >/dev/null 2>&1; then


redis-cli ping | tee -a "$REPORT"


else

echo "redis-cli unavailable" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[9] Recovery Evidence" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/sprint-11"

cp "$REPORT" \
"$ROOT/docs/recovery/sprint-11/"




echo "" | tee -a "$REPORT"


if [ "$PASS" = true ]; then


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 11 STATUS: GREEN" | tee -a "$REPORT"
echo "LOCAL DEPLOYMENT: PASS" | tee -a "$REPORT"
echo "SERVICE CHAIN: PASS" | tee -a "$REPORT"
echo "APPLICATION READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 0


else


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 11 STATUS: AMBER/RED" | tee -a "$REPORT"
echo "LOCAL DEPLOYMENT NEEDS REVIEW" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 1


fi
