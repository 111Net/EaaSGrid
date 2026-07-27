
#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-16"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/monitoring-observability-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 16" | tee -a "$REPORT"
echo "Monitoring & Observability Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Monitoring Directory Setup" | tee -a "$REPORT"



MONITOR_DIR="$ROOT/monitoring"


mkdir -p "$MONITOR_DIR"


echo "Created: $MONITOR_DIR" | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[2] Service Health Monitoring" | tee -a "$REPORT"



SERVICES=(
postgresql
redis-server
nginx
)



for SERVICE in "${SERVICES[@]}"
do


if systemctl is-active --quiet "$SERVICE"; then


echo "$SERVICE : HEALTHY" | tee -a "$R
