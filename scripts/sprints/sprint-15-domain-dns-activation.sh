

#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-15"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/domain-dns-activation-report.txt"


PASS=true


DOMAIN="www.eaasgrid.com"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 15" | tee -a "$REPORT"
echo "Domain & DNS Activation Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Domain Configuration Check" | tee -a "$REPORT"



echo "Target Domain: $DOMAIN" | tee -a "$REPORT"



if command -v dig >/dev/null 2>&1; then


DNS_RESULT=$(dig +short "$DOMAIN")


if [ -n "$DNS_RESULT" ]; then


echo "DNS RECORD FOUND" | tee -a "$REPORT"

echo "$DNS_RESULT" | tee -a "$REPORT"


else


echo "DNS RECORD NOT FOUND" | tee -a "$REPORT"


fi


else


echo "dig utility unavailable" 



