
#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-14"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/production-deployment-report.txt"

PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 14" | tee -a "$REPORT"
echo "Production Deployment Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] Operating System Validation" | tee -a "$REPORT"


if command -v lsb_release >/dev/null 2>&1; then

lsb_release -a | tee -a "$REPORT"

else

cat /etc/os-release | tee -a "$REPORT"

fi




echo "" | tee -a "$REPORT"
echo "[2] Required Runtime Check" | tee -a "$REPORT"


TOOLS=(
git
curl
docker
node
npm
python3
)


for TOOL in "${TOOLS[@]}"
do

if command -v "$TOOL" >/dev/null 2>&1; then

echo "$TOOL : AVAILABLE" | tee -a "$REP


