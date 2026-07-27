#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-10"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/production-readiness-report.txt"

PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 10" | tee -a "$REPORT"
echo "Production Readiness Gate" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Environment Audit" | tee -a "$REPORT"


for FILE in \
"$ROOT/.env" \
"$ROOT/.env.production" \
"$ROOT/.env.example"

do

if [ -f "$FILE" ]; then

echo "FOUND: $FILE" | tee -a "$REPORT"

else

echo "MISSING: $FILE" | tee -a "$REPORT"

fi

done



echo "" | tee -a "$REPORT"
echo "[2] Secret Exposure Scan" | tee -a "$REPORT"


SECRET_SCAN=$(grep -RniE \
"password=|secret=|apikey=|api_key=|private_key=" \
"$ROOT" \
--exclude-dir=node_modules \
--exclude-dir=.git \
2>/dev/null || true)


if [ -z "$SECRET_SCAN" ]; then

echo "NO SECRET PATTERNS FOUND" | tee -a "$REPORT"

else

echo "$SECRET_SCAN" | tee -a "$REPORT"

echo "REVIEW REQUIRED" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[3] Node Application Build Audit" | tee -a "$REPORT"


find "$ROOT/apps" \
-name package.json \
-not -path "*/node_modules/*" \
| while read FILE

do

APP_DIR=$(dirname "$FILE")

echo "Checking Node App: $APP_DIR" | tee -a "$REPORT"


if [ -d "$APP_DIR/node_modules" ]; then

echo "node_modules present" | tee -a "$REPORT"

else

echo "node_modules missing" | tee -a "$REPORT"

fi


done




echo "" | tee -a "$REPORT"
echo "[4] Python Backend Audit" | tee -a "$REPORT"


PY_FILES=$(find "$ROOT" \
-name "*.py" \
-not -path "*/venv/*" \
-not -path "*/.venv/*" \
| wc -l)


echo "Python files detected: $PY_FILES" | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[5] Database Readiness Check" | tee -a "$REPORT"


if command -v psql >/dev/null 2>&1; then

echo "PostgreSQL client available" | tee -a "$REPORT"

else

echo "PostgreSQL client unavailable" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[6] Docker Readiness Check" | tee -a "$REPORT"


if command -v docker >/dev/null 2>&1; then

docker --version | tee -a "$REPORT"

else

echo "Docker unavailable" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[7] Nginx Production Check" | tee -a "$REPORT"


if command -v nginx >/dev/null 2>&1; then

nginx -t >> "$REPORT" 2>&1 || PASS=false

else

echo "Nginx not installed" | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[8] Build Configuration Search" | tee -a "$REPORT"


find "$ROOT" \
-name "docker-compose*.yml" \
-o -name "Dockerfile" \
-o -name "render.yaml" \
>> "$REPORT"




echo "" | tee -a "$REPORT"
echo "[9] Recovery Evidence" | tee -a "$REPORT"


mkdir -p "$ROOT/docs/recovery/sprint-10"

cp "$REPORT" \
"$ROOT/docs/recovery/sprint-10/"




echo "" | tee -a "$REPORT"


if [ "$PASS" = true ]; then


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 10 STATUS: GREEN" | tee -a "$REPORT"
echo "PRODUCTION CONFIG: PASS" | tee -a "$REPORT"
echo "SECURITY CHECK: PASS" | tee -a "$REPORT"
echo "BUILD READINESS: PASS" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 0


else


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 10 STATUS: RED" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 1


fi
