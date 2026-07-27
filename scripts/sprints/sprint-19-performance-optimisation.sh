

#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-19"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/performance-optimisation-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 19" | tee -a "$REPORT"
echo "Performance Optimisation Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] System Resource Baseline" | tee -a "$REPORT"


echo "CPU:" | tee -a "$REPORT"

nproc | tee -a "$REPORT"


echo "Memory:" | tee -a "$REPORT"

free -h | tee -a "$REPORT"


echo "Disk:" | tee -a "$REPORT"

df -h | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[2] Application Response Testing" | tee -a "$REPORT"



ENDPOINTS=(

"http://localhost:4000/api/v1/health"

"http://localhost:4000/api/v1/dashboard"

"http


