#!/bin/bash

BASE="/data/eaasgrid-platform"
REPORT="$BASE/reports/browser-role-matrix-$(date +%F_%H-%M-%S).log"
MAP="$BASE/scripts/guardian/role-access-map.json"

mkdir -p "$BASE/reports"


echo "============================================" | tee -a $REPORT
echo " EaaSGrid Browser Role Matrix Intelligence Engine" | tee -a $REPORT
echo " Module 10" | tee -a $REPORT
date | tee -a $REPORT
echo "============================================" | tee -a $REPORT


echo "" | tee -a $REPORT
echo "1. DISCOVER FRONTEND" | tee -a $REPORT


DASHBOARD="http://192.168.100.21:3000"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $DASHBOARD/login)

echo "Dashboard login HTTP: $STATUS" | tee -a $REPORT


if [ "$STATUS" = "200" ]; then
echo "[PASS] Login page available" | tee -a $REPORT
else
echo "[FAIL] Login page unavailable" | tee -a $REPORT
fi



echo "" | tee -a $REPORT
echo "2. API LOGIN CONTRACT" | tee -a $REPORT


API="http://192.168.100.21:4000"


LOGIN=$(curl -s \
-X POST \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}' \
$API/api/v1/auth/login)


echo "$LOGIN" | tee -a $REPORT


TOKEN=$(echo $LOGIN | grep -o '"token":"[^"]*"' )


if [ -n "$TOKEN" ]; then
echo "[PASS] JWT generated" | tee -a $REPORT
else
echo "[FAIL] JWT missing" | tee -a $REPORT
fi



echo "" | tee -a $REPORT
echo "3. ROLE MATRIX" | tee -a $REPORT


ROLES=(
ADMIN
OPERATIONS
PARTNER
INVESTOR
CUSTOMER
COLLABORATOR
)


for ROLE in "${ROLES[@]}"
do

echo "--------------------------------" | tee -a $REPORT
echo "Testing Role: $ROLE" | tee -a $REPORT


case $ROLE in

ADMIN)
ROUTE="/control-centre"
;;

OPERATIONS)
ROUTE="/operations"
;;

PARTNER)
ROUTE="/partner"
;;

INVESTOR)
ROUTE="/investor"
;;

CUSTOMER)
ROUTE="/customer"
;;

COLLABORATOR)
ROUTE="/collaborator"
;;

esac


HTTP=$(curl -s \
-o /dev/null \
-w "%{http_code}" \
$DASHBOARD$ROUTE)


echo "Route: $ROUTE" | tee -a $REPORT
echo "HTTP: $HTTP" | tee -a $REPORT


done



echo "" | tee -a $REPORT
echo "4. MIDDLEWARE CONTRACT" | tee -a $REPORT


grep -R "eaasgrid_token" \
$BASE/apps/dashboard \
2>/dev/null | tee -a $REPORT



echo "" | tee -a $REPORT
echo "5. GENERATING ROLE MAP" | tee $MAP


cat > $MAP <<EOF
{
"frontend":"Next.js",
"dashboard":"$DASHBOARD",
"api":"$API",
"roles":[
"ADMIN",
"OPERATIONS",
"PARTNER",
"INVESTOR",
"CUSTOMER",
"COLLABORATOR"
],
"protected_routes":[
"/control-centre",
"/operations",
"/partner",
"/investor",
"/customer"
],
"generated":"$(date)"
}
EOF


echo "[PASS] Role access map generated" | tee -a $REPORT



echo ""
echo "============================================"
echo "SUMMARY"
echo "STATUS: ROLE MATRIX COMPLETE"
echo "REPORT:"
echo "$REPORT"
echo "MAP:"
echo "$MAP"
echo "============================================"
