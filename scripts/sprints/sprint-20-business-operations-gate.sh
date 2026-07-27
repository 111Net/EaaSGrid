#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-20"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/business-operations-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 20" | tee -a "$REPORT"
echo "Business Operations Gate Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Business Module Inventory" | tee -a "$REPORT"



MODULES=(

customer
billing
payment
notification
install
dashboard
investor

)



for MODULE in "${MODULES[@]}"
do


FOUND=$(find "$ROOT" \
-type d \
-name "*$MODULE*" \
2>/dev/null | head -1)



if [ -n "$FOUND" ]; then


echo "$MODULE : FOUND" | tee -a "$REPORT"


else


echo "$MODULE : NOT FOUND - REVIEW" | tee -a "$REPORT"


fi


done




echo "" | tee -a "$REPORT"
echo


