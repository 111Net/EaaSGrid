#!/bin/bash

BASE="/data/eaasgrid-platform"
REPORT="$BASE/reports/api-contract-intelligence-$(date +%F_%H-%M-%S).log"
MAP="$BASE/scripts/guardian/api-route-authority-map.json"

mkdir -p "$BASE/reports"

echo "============================================" | tee -a $REPORT
echo " EaaSGrid API Contract Intelligence Engine" | tee -a $REPORT
echo " Module 09" | tee -a $REPORT
date | tee -a $REPORT
echo "============================================" | tee -a $REPORT


echo "" | tee -a $REPORT
echo "1. FRONTEND API REFERENCES" | tee -a $REPORT

grep -R "NEXT_PUBLIC_API_URL" \
$BASE/apps/dashboard \
2>/dev/null | tee -a $REPORT


echo "" | tee -a $REPORT
echo "2. LOGIN ENDPOINT REFERENCES" | tee -a $REPORT

grep -R "auth/login" \
$BASE/apps/dashboard \
2>/dev/null | tee -a $REPORT


echo "" | tee -a $REPORT
echo "3. EXPRESS ROUTE OWNERSHIP" | tee -a $REPORT

grep -R "app.use" \
$BASE/apps/api/src \
2>/dev/null | tee -a $REPORT


echo "" | tee -a $REPORT
echo "4. AUTH IMPLEMENTATIONS" | tee -a $REPORT

find $BASE/apps/api/src \
-name "*auth*" \
-type f | tee -a $REPORT


echo "" | tee -a $REPORT
echo "5. HEALTH CONTRACT TEST" | tee -a $REPORT

API=$(grep NEXT_PUBLIC_API_URL \
$BASE/apps/dashboard/.env* \
2>/dev/null | cut -d= -f2)

echo "API=$API" | tee -a $REPORT


curl -s "$API/api/v1/health" \
| tee -a $REPORT


echo "" | tee -a $REPORT
echo "6. GENERATING AUTHORITY MAP" | tee $MAP


cat > $MAP <<EOF
{
 "api_base":"$API",
 "health_endpoint":"/api/v1/health",
 "login_endpoint":"/api/v1/auth/login",
 "frontend":"Next.js",
 "backend":"Express",
 "database":"PostgreSQL",
 "generated":"$(date)"
}
EOF


echo "[PASS] API authority map created" | tee -a $REPORT


echo "" | tee -a $REPORT
echo "============================================"
echo "SUMMARY"
echo "STATUS: INTELLIGENCE COMPLETE"
echo "REPORT:"
echo "$REPORT"
echo "MAP:"
echo "$MAP"
echo "============================================"
