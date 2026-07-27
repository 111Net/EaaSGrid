#!/bin/bash

#############################################
# EaaSGrid Dependency Verification Engine
# Module 02
#############################################

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$REPORT"

LOG="$REPORT/dependency-verification-$DATE.log"

exec > >(tee -a "$LOG") 2>&1


echo "=========================================="
echo " EaaSGrid Dependency Verification Engine "
echo " Module 02"
echo " $DATE"
echo "=========================================="



FAILURES=0



function CHECK()
{
    NAME=$1
    COMMAND=$2

    echo ""
    echo "--------------------------------"
    echo "CHECK:"
    echo "$NAME"
    echo "--------------------------------"

    eval "$COMMAND"

    if [ $? -eq 0 ]; then
        echo "STATUS: PASS"
    else
        echo "STATUS: FAIL"
        FAILURES=$((FAILURES+1))
    fi
}



#############################################
# 1. Project Structure
#############################################

CHECK \
"Dashboard exists" \
"test -d $ROOT/apps/dashboard"



CHECK \
"API exists" \
"test -d $ROOT/apps/api"



CHECK \
"Database directory exists" \
"test -d $ROOT/database"



#############################################
# 2. Frontend Verification
#############################################

CHECK \
"Next.js package" \
"test -f $ROOT/apps/dashboard/package.json"



CHECK \
"Environment API URL" \
"grep NEXT_PUBLIC_API_URL $ROOT/apps/dashboard/.env.local"



CHECK \
"Login module exists" \
"test -f $ROOT/apps/dashboard/lib/auth.js"



CHECK \
"Login page exists" \
"test -f $ROOT/apps/dashboard/app/login/page.jsx"



#############################################
# 3. Next.js Runtime
#############################################

echo ""
echo "Checking Next.js process"

ps aux | grep "next" | grep -v grep



if ps aux | grep next | grep -v grep >/dev/null
then
 echo "NEXT STATUS: RUNNING"
else
 echo "NEXT STATUS: DOWN"
 FAILURES=$((FAILURES+1))
fi



#############################################
# 4. API Runtime
#############################################

echo ""
echo "Checking API port"

if curl -s http://192.168.100.21:4000/health >/dev/null
then
 echo "API HEALTH: PASS"
else
 echo "API HEALTH: FAIL"
 FAILURES=$((FAILURES+1))
fi



#############################################
# 5. Authentication Route Discovery
#############################################

echo ""
echo "Searching authentication routes"

grep -R \
"login" \
$ROOT/apps/api/src \
--exclude-dir=node_modules \
2>/dev/null



#############################################
# 6. Database Verification
#############################################

echo ""
echo "Checking PostgreSQL"

if systemctl status postgresql >/dev/null 2>&1
then
 echo "POSTGRES SERVICE: FOUND"
else
 echo "POSTGRES SERVICE: UNKNOWN"
fi



echo ""
echo "Database users"

sudo -u postgres psql \
-c "\du" \
2>/dev/null



#############################################
# 7. User Table Discovery
#############################################

echo ""

sudo -u postgres psql \
-d eaas_db \
-c "\dt" \
2>/dev/null



#############################################
# 8. Login Endpoint Test
#############################################

echo ""
echo "Testing login endpoint"

curl \
-s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}'



echo ""



#############################################
# 9. Browser Dependency Report
#############################################

echo ""
echo "Frontend API TARGET"

grep \
NEXT_PUBLIC_API_URL \
$ROOT/apps/dashboard/.env.local



#############################################
# Final Report
#############################################

echo ""
echo "=========================================="
echo "DEPENDENCY VERIFICATION COMPLETE"
echo "Failures:"
echo "$FAILURES"
echo "Report:"
echo "$LOG"
echo "=========================================="



if [ $FAILURES -eq 0 ]
then
 exit 0
else
 exit 1
fi
