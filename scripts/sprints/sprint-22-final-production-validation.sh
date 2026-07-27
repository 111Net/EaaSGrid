
#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-22"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/final-production-validation-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 22" | tee -a "$REPORT"
echo "Final Production Validation & Go-Live Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Repository Final Integrity Check" | tee -a "$REPORT"


cd "$ROOT"


git status --short | tee -a "$REPORT"


if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

echo "Git Repository: PASS" | tee -a "$REPORT"

else

echo "Git Repository: FAIL" | tee -a "$REPORT"

PASS=false

fi




echo "" | tee -a "$REPORT"
echo "[2] Service Availability Check" | tee -a "$REPORT"



SERVICES=(

postgresql
red

