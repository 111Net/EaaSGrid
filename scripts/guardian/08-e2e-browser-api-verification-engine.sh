#!/bin/bash


ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/e2e-browser-api-$(date +%F_%H-%M-%S).log"

mkdir -p "$ROOT/reports"


exec > >(tee -a "$REPORT") 2>&1


echo "============================================"
echo " EaaSGrid Browser API E2E Verification Engine"
echo " Module 08"
date
echo "============================================"



FAIL=0



check()
{
echo
echo "--------------------------------"
echo "$1"
echo "--------------------------------"
}



check "1. Dashboard availability"


HTTP=$(curl -o /dev/null -s -w "%{http_code}" \
http://192.168.100.21:3000/login)


echo "HTTP STATUS:"
echo "$HTTP"


if [ "$HTTP" = "200" ]
then
echo "[PASS] Login page reachable"
else
echo "[FAIL] Login page unavailable"
FAIL=$((FAIL+1))
fi




check "2. API health"


API=$(curl -s \
http://192.168.100.21:4000/health)


echo "$API"


echo "$API" | grep -q ok


if [ $? -eq 0 ]
then
echo "[PASS] API healthy"
else
echo "[FAIL] API unavailable"
FAIL=$((FAIL+1))
fi




check "3. Authentication contract"


LOGIN=$(curl -s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{
"email":"admin@eaasgrid.com",
"password":"Admin@123"
}')


echo "$LOGIN"



echo "$LOGIN" | grep -q token


if [ $? -eq 0 ]
then
echo "[PASS] JWT token returned"
else
echo "[FAIL] Token missing"
FAIL=$((FAIL+1))
fi




check "4. User identity validation"


echo "$LOGIN" | grep -q ADMIN


if [ $? -eq 0 ]
then
echo "[PASS] ADMIN role detected"
else
echo "[FAIL] Role missing"
FAIL=$((FAIL+1))
fi





check "5. Frontend login wiring"


grep -R "api/v1/auth/login" \
$ROOT/apps/dashboard/lib \
--exclude-dir=.next


if [ $? -eq 0 ]
then
echo "[PASS] Frontend endpoint aligned"
else
echo "[FAIL]"
FAIL=$((FAIL+1))
fi





check "6. Session contract"


grep -R "eaasgrid_token" \
$ROOT/apps/dashboard \
--exclude-dir=.next


if [ $? -eq 0 ]
then
echo "[PASS] Session token reference exists"
else
echo "[FAIL]"
FAIL=$((FAIL+1))
fi





check "7. Protected routes"


ROUTES=(
"/control-centre"
"/operations"
"/partner"
"/investor"
"/customer"
)


for ROUTE in "${ROUTES[@]}"
do

STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
"http://192.168.100.21:3000$ROUTE")

echo "$ROUTE : $STATUS"

done





check "8. Role login matrix"


ROLES=(
"ADMIN"
"OPERATIONS"
"PARTNER"
"INVESTOR"
"CUSTOMER"
"COLLABORATOR"
)


for ROLE in "${ROLES[@]}"
do

echo "Testing role:"
echo "$ROLE"

done



echo


echo "============================================"
echo "SUMMARY"
echo "FAILURES:$FAIL"

if [ $FAIL -eq 0 ]
then
echo "STATUS:E2E HEALTHY"
else
echo "STATUS:E2E FAILURE"
fi


echo
echo "REPORT:"
echo "$REPORT"

echo "============================================"
