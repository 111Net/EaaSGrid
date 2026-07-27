#!/bin/bash

############################################
# EaaSGrid Authentication Path Validation
# Module 03
############################################

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$REPORT"

LOG="$REPORT/auth-path-$DATE.log"

exec > >(tee -a "$LOG") 2>&1


echo "======================================"
echo " EaaSGrid Authentication Path Engine "
echo " Module 03"
echo "$DATE"
echo "======================================"


FAIL=0


check()
{
TITLE=$1
CMD=$2

echo ""
echo "------------------------------"
echo "$TITLE"
echo "------------------------------"

eval "$CMD"

if [ $? -eq 0 ]
then
echo "[PASS]"
else
echo "[FAIL]"
FAIL=$((FAIL+1))
fi
}



############################################
# Frontend login implementation
############################################


check \
"auth.js exists" \
"test -f $ROOT/apps/dashboard/lib/auth.js"



echo ""
echo "AUTH FUNCTION"

grep -n "login" \
$ROOT/apps/dashboard/lib/auth.js



echo ""
echo "SESSION HANDLING"

grep -n "saveSession" \
$ROOT/apps/dashboard/lib/auth.js



############################################
# Login page
############################################


check \
"Login page exists" \
"test -f $ROOT/apps/dashboard/app/login/page.jsx"



echo ""
echo "LOGIN FLOW"

grep -n "login(" \
$ROOT/apps/dashboard/app/login/page.jsx



grep -n "saveSession" \
$ROOT/apps/dashboard/app/login/page.jsx



############################################
# Middleware
############################################


check \
"Middleware exists" \
"test -f $ROOT/apps/dashboard/middleware.js"



echo ""
echo "MIDDLEWARE RULES"

cat $ROOT/apps/dashboard/middleware.js



############################################
# API response contract
############################################


echo ""
echo "Testing API RESPONSE CONTRACT"


RESPONSE=$(curl -s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}')


echo "$RESPONSE"



echo "$RESPONSE" | grep token >/dev/null

if [ $? -eq 0 ]
then
echo "[PASS] Token returned"
else
echo "[FAIL] Token missing"
FAIL=$((FAIL+1))
fi



echo "$RESPONSE" | grep user >/dev/null

if [ $? -eq 0 ]
then
echo "[PASS] User object returned"
else
echo "[FAIL] User object missing"
FAIL=$((FAIL+1))
fi



############################################
# Search redirect logic
############################################


echo ""
echo "REDIRECT SEARCH"


grep -R "router.push" \
$ROOT/apps/dashboard/app \
--exclude-dir=.next



############################################
# Search dashboard guards
############################################


echo ""
echo "SESSION GUARDS"


grep -R \
"eaasgrid_token" \
$ROOT/apps/dashboard \
--exclude-dir=.next



############################################
# Summary
############################################


echo ""
echo "======================================"
echo "AUTH PATH COMPLETE"
echo "FAILURES:"
echo "$FAIL"
echo "REPORT:"
echo "$LOG"
echo "======================================"


exit $FAIL
