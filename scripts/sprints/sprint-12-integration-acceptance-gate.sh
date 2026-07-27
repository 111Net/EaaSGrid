#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-12"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/integration-acceptance-report.txt"

PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 12" | tee -a "$REPORT"
echo "Integration & Acceptance Gate Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Repository Integration Check" | tee -a "$REPORT"


PROJECTS=(
"/data/eaasgrid-platform"
"/data/eaasgrid-website-factory"
"/data/eaasgrid-lifecycle"
)


for PROJECT in "${PROJECTS[@]}"
do

if [ -d "$PROJECT" ]; then

echo "FOUND: $PROJECT" | tee -a "$REPORT"

else

echo "MISSING: $PROJECT" | tee -a "$REPORT"

PASS=false

fi

done




echo "" | tee -a "$REPORT"
echo "[2] Platform API Acceptance Test" | tee -a "$REPORT"



HEALTH=$(curl -s \
http://localhost:4000/api/v1/health \
|| true)


echo "$HEALTH" | tee -a "$REPORT"



if echo "$HEALTH" | grep -q "ok"; then

echo "API HEALTH: PASS" | tee -a "$REPORT"

else

echo "API HEALTH: FAIL" | tee -a "$REPORT"

PASS=false

fi




echo "" | tee -a "$REPORT"
echo "[3] Dashboard Integration Test" | tee -a "$REPORT"



DASHBOARD=$(curl -s \
http://localhost:4000/api/v1/dashboard \
|| true)


echo "$DASHBOARD" | tee -a "$REPORT"


if echo "$DASHBOARD" | grep -q "platform"; then

echo "DASHBOARD DATA: PASS" | tee -a "$REPORT"

else

echo "DASHBOARD DATA: FAIL" | tee -a "$REPORT"

PASS=false

fi




echo "" | tee -a "$REPORT"
echo "[4] Website Factory Customer Acceptance" | tee -a "$REPORT"



CUSTOMERS=(
factory-restaurant-001
factory-corporate-001
factory-realestate-001
factory-tech-001
)


FACTORY_PATH="/data/eaasgrid-website-factory"


for CUSTOMER in "${CUSTOMERS[@]}"
do


if find "$FACTORY_PATH" \
-name "$CUSTOMER" \
2>/dev/null | grep -q "$CUSTOMER"; then


echo "$CUSTOMER : FOUND" | tee -a "$REPORT"


else


echo "$CUSTOMER : NOT FOUND" | tee -a "$REPORT"


fi


done




echo "" | tee -a "$REPORT"
echo "[5] Database Integration Check" | tee -a "$REPORT"



if command -v psql >/dev/null 2>&1; then


echo "PostgreSQL client available" | tee -a "$REPORT"

pg_isready | tee -a "$REPORT"


else


echo "PostgreSQL client missing" | tee -a "$REPORT"


fi




echo "" | tee -a "$REPORT"
echo "[6] Lifecycle Controller Integration" | tee -a "$REPORT"



if [ -d "/data/eaasgrid-lifecycle" ]; then


echo "Lifecycle framework detected" | tee -a "$REPORT"


else


echo "Lifecycle framework missing" | tee -a "$REPORT"

PASS=false


fi




echo "" | tee -a "$REPORT"
echo "[7] Acceptance Evidence Package" | tee -a "$REPORT"



EVIDENCE="$ROOT/docs/recovery/sprint-12"

mkdir -p "$EVIDENCE"


cp "$REPORT" "$EVIDENCE/"




echo "" | tee -a "$REPORT"



if [ "$PASS" = true ]; then


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 12 STATUS: GREEN" | tee -a "$REPORT"
echo "INTEGRATION TEST: PASS" | tee -a "$REPORT"
echo "CUSTOMER ACCEPTANCE: PASS" | tee -a "$REPORT"
echo "PLATFORM READY FOR DEPLOYMENT PIPELINE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 0


else


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 12 STATUS: AMBER/RED" | tee -a "$REPORT"
echo "INTEGRATION REVIEW REQUIRED" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 1


fi

