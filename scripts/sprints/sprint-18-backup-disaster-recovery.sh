#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-18"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/disaster-recovery-report.txt"


PASS=true


BACKUP_DIR="$ROOT/backups/$DATE"


mkdir -p "$BACKUP_DIR"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 18" | tee -a "$REPORT"
echo "Backup & Disaster Recovery Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Backup Directory Creation" | tee -a "$REPORT"



echo "Backup Location:" | tee -a "$REPORT"

echo "$BACKUP_DIR" | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[2] Application Backup" | tee -a "$REPORT"



tar \
--exclude=node_modules \
--exclude=.next \
--exclude=.git \
-czf \
"$BACKUP_DIR/eaasgrid-platform-files-$DATE.tar.gz" \
"$ROOT"



if [ -f "$BACK

