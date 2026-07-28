#!/bin/bash

set -e

ROOT="/data/eaasgrid-platform"
REPORT_DIR="$ROOT/reports/repository"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT="$REPORT_DIR/duplicate-analysis-$DATE.txt"

mkdir -p "$REPORT_DIR"


echo "======================================" > "$REPORT"
echo " EaaSGrid Duplicate Detection Engine" >> "$REPORT"
echo " Sprint 0.3" >> "$REPORT"
echo " Date: $(date)" >> "$REPORT"
echo " Repository: $ROOT" >> "$REPORT"
echo "======================================" >> "$REPORT"


echo "" >> "$REPORT"
echo "[1] Duplicate File Names" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type f \
-not -path "*/node_modules/*" \
-not -path "*/.next/*" \
-printf "%f\n" | sort | uniq -d >> "$REPORT"



echo "" >> "$REPORT"
echo "[2] Backup File Detection" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type f \
\( -name "*.backup*" \
-o -name "*.bak" \
-o -name "*.broken*" \
-o -name "*~" \) \
-not -path "*/node_modules/*" \
>> "$REPORT"



echo "" >> "$REPORT"
echo "[3] Package Inventory" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-name package.json \
-not -path "*/node_modules/*" \
-not -path "*/.next/*" \
>> "$REPORT"



echo "" >> "$REPORT"
echo "[4] Script Family Inventory" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT/scripts" \
-type f \
-name "*.sh" \
| sed 's#.*/##' \
| sort \
>> "$REPORT"



echo "" >> "$REPORT"
echo "[5] Large Archive Candidates (>50MB)" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type f \
-size +50M \
-not -path "*/node_modules/*" \
-not -path "*/.git/*" \
>> "$REPORT"



echo "" >> "$REPORT"
echo "======================================" >> "$REPORT"
echo " Duplicate Detection Complete" >> "$REPORT"
echo " Report:" >> "$REPORT"
echo "$REPORT" >> "$REPORT"


echo "$REPORT"
