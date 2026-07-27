#!/bin/bash

#############################################
# EaaSGrid Platform Self Healing Controller
# Version: 1.0
# Purpose:
# Automated recovery, audit and prevention
#############################################

set -e

ROOT="/data/eaasgrid-platform"
LOG="$ROOT/scripts/guardian/logs"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p $LOG

REPORT="$LOG/guardian-$DATE.log"

exec > >(tee -a $REPORT)
exec 2>&1


echo "======================================"
echo " EaaSGrid Guardian Started"
echo " $DATE"
echo "======================================"



#############################################
# SYSTEM CHECK
#############################################

echo "[1] Checking system"

df -h

free -h

uptime



#############################################
# NETWORK CHECK
#############################################

echo "[2] Network"

IP=$(hostname -I | awk '{print $1}')

echo "Server IP: $IP"

ping -c 2 8.8.8.8 || echo "Internet issue"



#############################################
# PORT CLEANUP
#############################################

echo "[3] Checking ports"


for PORT in 3000 3001 3002 3003 4000; do

PID=$(lsof -ti:$PORT || true)

if [ ! -z "$PID" ]; then

echo "Port $PORT used by $PID"

fi

done



#############################################
# POSTGRES CHECK
#############################################

echo "[4] PostgreSQL"


if systemctl is-active --quiet postgresql
then

echo "Postgres OK"

else

echo "Restarting PostgreSQL"

sudo systemctl restart postgresql

fi



#############################################
# DATABASE CONNECTION
#############################################

echo "[5] Database"


sudo -u postgres psql <<EOF

SELECT datname 
FROM pg_database;

EOF



#############################################
# REDIS CHECK
#############################################

echo "[6] Redis"


if systemctl is-active --quiet redis
then

echo "Redis OK"

else

sudo systemctl restart redis

fi



#############################################
# NODE ENVIRONMENT
#############################################

echo "[7] Node Environment"

node -v

npm -v



#############################################
# INSTALL DEPENDENCIES
#############################################

echo "[8] Dependency repair"


APPS="
apps/api
apps/dashboard
apps/investor-portal
"


for APP in $APPS
do

if [ -d "$ROOT/$APP" ]
then

echo "Checking $APP"

cd $ROOT/$APP


if [ -f package.json ]
then

npm install

fi


fi

done



#############################################
# ENVIRONMENT VALIDATION
#############################################

echo "[9] Environment"


for ENVFILE in $(find $ROOT -name ".env")
do

echo "Checking $ENVFILE"

cat $ENVFILE

done



#############################################
# API CHECK
#############################################

echo "[10] API"


curl -f http://localhost:4000/api/v1/health \
&& echo "API HEALTHY" \
|| echo "API FAILED"



#############################################
# DASHBOARD CHECK
#############################################

echo "[11] Dashboard"


curl -I http://localhost:3000 \
|| echo "Dashboard not running"



#############################################
# BUILD VALIDATION
#############################################

echo "[12] Build test"


cd $ROOT/apps/dashboard

npm run build || echo "Dashboard build requires attention"



cd $ROOT/apps/investor-portal

npm run build || echo "Investor portal build requires attention"



#############################################
# DATABASE MIGRATION CHECK
#############################################

echo "[13] Migration audit"


if [ -f "$ROOT/scripts/eaas-migration-audit.sh" ]
then

bash $ROOT/scripts/eaas-migration-audit.sh

fi



#############################################
# SECURITY CHECK
#############################################

echo "[14] Security"


find $ROOT \
-type f \
-name "*.env" \
-print



#############################################
# BACKUP
#############################################

echo "[15] Recovery Snapshot"


BACKUP="/data/backups/eaasgrid"

mkdir -p $BACKUP


tar -czf \
$BACKUP/eaasgrid-$DATE.tar.gz \
$ROOT/apps \
$ROOT/packages \
$ROOT/database



#############################################
# FINAL STATUS
#############################################

echo "======================================"

echo "EaaSGrid Guardian Completed"

echo "Report:"
echo $REPORT

echo "======================================"
