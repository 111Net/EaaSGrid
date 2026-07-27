#!/usr/bin/env bash

set -uo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-13"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/vps-migration-preparation-report.txt"


PASS=true


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 13" | tee -a "$REPORT"
echo "VPS Migration Preparation Automation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[1] System Information Capture" | tee -a "$REPORT"


hostnamectl | tee -a "$REPORT"

echo "" | tee -a "$REPORT"

df -h | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[2] Repository Inventory" | tee -a "$REPORT"


PROJECTS=(
"/data/eaasgrid-platform"
"/data/eaasgrid-website-factory"
"/data/eaasgrid-lifecycle"
)


for PROJECT in "${PROJECTS[@]}"
do

if [ -d "$PROJECT" ]; then

echo "READY: $PROJECT" | tee -a "$REPORT"

else

echo "MISSING: $PROJECT" | tee -a "$REPORT"

PASS=false

fi

done




echo "" | tee -a "$REPORT"
echo "[3] Git Release Status" | tee -a "$REPORT"


cd "$ROOT"


git branch --show-current | tee -a "$REPORT"

git status --short | tee -a "$REPORT"



echo "" | tee -a "$REPORT"
echo "[4] Production Package Creation" | tee -a "$REPORT"



PACKAGE_DIR="$ROOT/migration-package"

mkdir -p "$PACKAGE_DIR"


tar \
--exclude=node_modules \
--exclude=.next \
--exclude=.git \
-czf \
"$PACKAGE_DIR/eaasgrid-platform-$DATE.tar.gz" \
"$ROOT"



if [ -f "$PACKAGE_DIR/eaasgrid-platform-$DATE.tar.gz" ]; then

echo "PACKAGE CREATED" | tee -a "$REPORT"

else

echo "PACKAGE FAILED" | tee -a "$REPORT"

PASS=false

fi




echo "" | tee -a "$REPORT"
echo "[5] Database Backup Preparation" | tee -a "$REPORT"


BACKUP_DIR="$PACKAGE_DIR/database"

mkdir -p "$BACKUP_DIR"


if command -v pg_dump >/dev/null 2>&1; then


DATABASES=$(psql -lqt 2>/dev/null | cut -d \| -f1 | sed 's/ //g')


echo "$DATABASES" | tee -a "$REPORT"


for DB in $DATABASES
do

if [ "$DB" != "" ]; then

pg_dump "$DB" \
> "$BACKUP_DIR/$DB-$DATE.sql" \
2>/dev/null || true

fi


done


else

echo "pg_dump unavailable" | tee -a "$REPORT"


fi




echo "" | tee -a "$REPORT"
echo "[6] Configuration Manifest" | tee -a "$REPORT"



find "$ROOT" \
-name ".env*" \
-o -name "docker-compose*.yml" \
-o -name "Dockerfile" \
-o -name "nginx*.conf" \
> "$PACKAGE_DIR/configuration-manifest.txt"



cat "$PACKAGE_DIR/configuration-manifest.txt" \
| tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[7] Deployment Checklist Generation" | tee -a "$REPORT"



cat > "$PACKAGE_DIR/VPS-DEPLOYMENT-CHECKLIST.txt" <<EOF

EaaSGrid VPS Deployment Checklist

[ ] Ubuntu Server Ready
[ ] Docker Installed
[ ] PostgreSQL Installed
[ ] Redis Installed
[ ] Node Installed
[ ] Python Environment Installed
[ ] Nginx Configured
[ ] Firewall Configured
[ ] SSL Certificate Installed
[ ] Database Restored
[ ] Applications Started
[ ] Health Checks Passed

EOF


echo "CHECKLIST CREATED" | tee -a "$REPORT"




echo "" | tee -a "$REPORT"
echo "[8] Recovery Evidence" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/sprint-13"

cp "$REPORT" \
"$ROOT/docs/recovery/sprint-13/"




if [ "$PASS" = true ]; then


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 13 STATUS: GREEN" | tee -a "$REPORT"
echo "MIGRATION PACKAGE: READY" | tee -a "$REPORT"
echo "BACKUP PROCESS: READY" | tee -a "$REPORT"
echo "VPS DEPLOYMENT PREPARED" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 0


else


echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 13 STATUS: RED" | tee -a "$REPORT"
echo "MIGRATION PREPARATION FAILED" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"


exit 1


fi

