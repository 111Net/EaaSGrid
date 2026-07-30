#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform

echo "======================================"
echo " XaaSGrid Sprint 3 Repository Cleanup"
echo "======================================"

cd $ROOT


echo "[1] Creating cleanup report"

mkdir -p reports


echo "[2] Checking secrets"

find . \
-name ".env" \
-o -name ".env.local" \
-o -name "*.pem" \
-o -name "*.key" \
> reports/sprint03-secret-scan.txt || true



echo "[3] Creating repository folders"

mkdir -p \
docs \
database \
scripts/sprints \
state \
reports



echo "[4] Creating environment template"

if [ -f .env ]; then

cp .env .env.example

sed -i \
-e 's/=.*/=CHANGE_ME/g' \
.env.example

fi



echo "[5] Updating gitignore"

cat >> .gitignore <<EOF

# XaaSGrid runtime
.env
.env.local
*.log
.next
node_modules
coverage
dist

# OS
.DS_Store

EOF



echo "[6] Repository inventory"

{
echo "# XaaSGrid Sprint 3 Repository Cleanup"
echo
date
echo
echo "Applications:"
ls apps
echo
echo "Packages:"
ls packages 2>/dev/null || true
echo
echo "Scripts:"
find scripts -maxdepth 2 -type f
} > reports/sprint03-cleanup-report.md



echo "[7] Update platform state"

cat > state/platform-state.json <<EOF
{
 "platform":"XaaSGrid",
 "current_sprint":3,
 "status":"repository-cleanup-complete",
 "version_control":"git",
 "portable_ready":false
}
EOF


echo
echo "======================================"
echo " Sprint 3 Repository Cleanup Complete"
echo "======================================"

echo
echo "Review:"
echo "reports/sprint03-cleanup-report.md"





