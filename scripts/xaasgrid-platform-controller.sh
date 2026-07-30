#!/bin/bash

set -u

BASE=/data/eaasgrid-platform
REPORT_DIR=$BASE/reports/platform-controller
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT=$REPORT_DIR/controller-$DATE.txt


mkdir -p $REPORT_DIR


log()
{
echo "$1" | tee -a $REPORT
}


log "=========================================="
log " XaaSGrid Platform Controller"
log " Startup + Health + Recovery"
log " $DATE"
log "=========================================="


####################################
# DATABASE
####################################

log ""
log "[1] PostgreSQL"

if systemctl is-active postgresql >/dev/null
then
log "PASS - PostgreSQL running"
else

log "Starting PostgreSQL"

sudo systemctl start postgresql

fi



####################################
# API
####################################

log ""
log "[2] API Service"


cd $BASE/apps/api


if ps aux | grep "node src/server.js" | grep -v grep >/dev/null
then

log "PASS - API already running"

else

log "Starting API"

nohup npm start > api-runtime.log 2>&1 &

sleep 5

fi


API=$(curl -s http://localhost:4000/api/v1/health)


if echo "$API" | grep -q ok
then

log "PASS - API healthy"

else

log "FAIL - API unavailable"

fi



####################################
# DASHBOARD
####################################


log ""
log "[3] Dashboard"


cd $BASE/apps/dashboard


if ss -tulnp | grep ":3000" >/dev/null
then

log "PASS - Dashboard running"

else

log "Starting Dashboard"


nohup npm run dev > dashboard-runtime.log 2>&1 &

sleep 10

fi



####################################
# INVESTOR PORTAL
####################################


log ""
log "[4] Investor Portal"


if [ -d "$BASE/apps/investor-portal" ]
then

cd $BASE/apps/investor-portal


if ss -tulnp | grep ":3001" >/dev/null
then

log "PASS - Investor portal running"

else

log "Starting Investor portal"

nohup npm run dev -- -p 3001 \
> investor-runtime.log 2>&1 &


fi

else

log "Investor portal directory missing"

fi




####################################
# FRONTEND BUILD VALIDATION
####################################


log ""
log "[5] Frontend Validation"


cd $BASE/apps/dashboard


BUILD=$(npm run build 2>&1)


if echo "$BUILD" | grep -q "Export getCurrentUser doesn't exist"
then


log "ERROR - Dashboard permission module broken"

log "$BUILD"


else

log "PASS - Dashboard build validation"

fi




####################################
# PERMISSION MODULE CHECK
####################################


log ""
log "[6] Permission Engine Check"


PERMISSION_FILE=$BASE/apps/dashboard/lib/permissions.js


if grep -q "getCurrentUser" $PERMISSION_FILE
then

log "PASS - getCurrentUser exists"

else

log "REPAIR REQUIRED - getCurrentUser missing"

fi



####################################
# LOG ANALYSIS
####################################


log ""
log "[7] Runtime Log Scan"


find $BASE/apps -name "*.log" | while read LOG
do

log "Checking $LOG"


grep -Ei \
"error|failed|exception|critical" \
$LOG \
| tail -10 \
| tee -a $REPORT


done



####################################
# ACTIVE SERVICES
####################################


log ""
log "[8] Active Services"


ps aux | grep node | grep -v grep \
| tee -a $REPORT


####################################
# DISK MEMORY
####################################


log ""
log "[9] Infrastructure"


df -h / | tee -a $REPORT

free -h | tee -a $REPORT



####################################
# REPORT
####################################


log ""

log "=========================================="
log " PLATFORM STATUS COMPLETE"
log "=========================================="

log ""
log "REPORT:"
log "$REPORT"
