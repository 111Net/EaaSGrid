#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-28"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/operations-console-gui-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 28" | tee -a "$REPORT"
echo "Operations Console GUI Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Operations Console Structure" | tee -a "$REPORT"



CONSOLE="$ROOT/apps/operations-console"



mkdir -p "$CONSOLE"

mkdir -p "$CONSOLE/dashboard"

mkdir -p "$CONSOLE/components"

mkdir -p "$CONSOLE/api"

mkdir -p "$CONSOLE/config"



echo "Operations Console structure created" | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[2] Dashboard Framework" | tee -a "$REPORT"



cat > "$CONSOLE/dashboard/dashboard-model.j

