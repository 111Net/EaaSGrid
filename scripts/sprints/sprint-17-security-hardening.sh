#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-17"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/security-hardening-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 17" | tee -a "$REPORT"
echo "Security Hardening Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] System Security Information" | tee -a "$REPORT"


uname -a | tee -a "$REPORT"

cat /etc/os-release | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[2] Firewall Audit" | tee -a "$REPORT"



if command -v ufw >/dev/null 2>&1; then


ufw status verbose | tee -a "$REPORT"


else


echo "UFW not installed" | tee -a "$REPORT"

PASS=false


fi




echo "" | tee -a "$REPORT"
echo "[3] Required Port Exposure Review" | tee -a "$REP









