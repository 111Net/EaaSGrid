#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-23"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/continuous-operations-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 23" | tee -a "$REPORT"
echo "Continuous Operations & Lifecycle Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Lifecycle Controller Detection" | tee -a "$REPORT"



LIFECYCLE="/data/eaasgrid-lifecycle"



if [ -d "$LIFECYCLE" ]; then

echo "Lifecycle Framework: FOUND" | tee -a "$REPORT"


else

echo "Lifecycle Framework: MISSING" | tee -a "$REPORT"

PASS=false


fi




echo "" | tee -a "$REPORT"
echo "[2] Daily Operations Directory Setup" | tee -a "$REPORT"



OPERATIONS="$ROOT/operations"


mkdir -p "$OPERATIONS/report

