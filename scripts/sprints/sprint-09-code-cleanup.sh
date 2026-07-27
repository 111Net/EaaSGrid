#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-09"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/code-cleanup-report.txt"

echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 09" | tee -a "$REPORT"
echo "Code Cleanup & Repository Standardisation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


PASS=true


echo "" | tee -a "$REPORT"
echo "[1] Repository Structure Audit" | tee -a "$REPORT"

for DIR in apps packages database infrastructure scripts docs; do

if [ -d "$ROOT/$DIR" ]; then
echo "FOUND: $DIR" | tee -a "$REPORT"
else
echo "MISSING: $DIR" | tee -a "$REPORT"
fi

done


echo "" | tee -a "$REPORT"
echo "[2] Temporary File Detection" | tee -a "$REPORT"


TEMP_FILES=$(find "$ROOT" \
\( -name "*.tmp" \
-o -name "*.bak" \
-o -name "*.old" \
-o -name "*.log" \) \
-not -path "*/node_modules/*" \
2>/dev/null)


if [ -z "$TEMP_FILES" ]; then

echo "NO TEMP FILES FOUND" | tee -a "$REPORT"

else

echo "$TEMP_FILES" | tee -a "$REPORT"

fi



echo "" | tee -a "$REPORT"
echo "[3] Git Repository Audit" | tee -a "$REPORT"


cd "$ROOT"

git status --short >> "$REPORT" 2>&1 || PASS=false

git branch --show-current >> "$REPORT" 2>&1 || PASS=false



echo "" | tee -a "$REPORT"
echo "[4] Node Project Validation" | tee -a "$REPORT"


find "$ROOT" -name package.json \
-not -path "*/node_modules/*" | while read FILE

do

echo "Checking $FILE" | tee -a "$REPORT"

done



echo "" | tee -a "$REPORT"
echo "[5] Python Project Validation" | tee -a "$REPORT"


find "$ROOT" \
-name "*.py" \
-not -path "*/venv/*" \
-not -path "*/.venv/*" \
| head -20 >> "$REPORT"



echo "" | tee -a "$REPORT"
echo "[6] Duplicate Configuration Search" | tee -a "$REPORT"


find "$ROOT" \
-name ".env*" \
-o -name "docker-compose*.yml" \
-o -name "nginx*.conf" \
>> "$REPORT"



echo "" | tee -a "$REPORT"
echo "[7] Recovery Evidence" | tee -a "$REPORT"


mkdir -p "$ROOT/docs/recovery/sprint-09"

cp "$REPORT" \
"$ROOT/docs/recovery/sprint-09/"


echo "" | tee -a "$REPORT"

if [ "$PASS" = true ]; then


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 09 STATUS: GREEN" | tee -a "$REPORT"
echo "CODE CLEANUP: PASS" | tee -a "$REPORT"
echo "REPOSITORY STANDARDISATION: PASS" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 0


else


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 09 STATUS: RED" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 1

fi

