#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/api-route-intelligence-$(date +%F_%H-%M-%S).log"

mkdir -p "$ROOT/reports"

exec > >(tee -a "$REPORT") 2>&1


echo "============================================"
echo " EaaSGrid API Route Intelligence Engine"
echo " Module 08B"
date
echo "============================================"


API="$ROOT/apps/api"

echo
echo "--------------------------------"
echo "1. Discover Express routes"
echo "--------------------------------"


grep -R "router\|app.use\|get(\|post(" \
$API/src \
--include="*.js"



echo
echo "--------------------------------"
echo "2. Search health routes"
echo "--------------------------------"


grep -R "health" \
$API/src \
--include="*.js"



echo
echo "--------------------------------"
echo "3. Test common health endpoints"
echo "--------------------------------"


for ENDPOINT in \
"/health" \
"/api/health" \
"/api/v1/health" \
"/api/status"

do

echo
echo "Testing:"
echo "$ENDPOINT"


RESULT=$(curl -s \
http://192.168.100.21:4000$ENDPOINT)


echo "$RESULT"


done



echo
echo "--------------------------------"
echo "4. Discover auth routes"
echo "--------------------------------"


grep -R "auth" \
$API/src/routes \
--include="*.js"



echo
echo "--------------------------------"
echo "5. Generate Guardian API map"
echo "--------------------------------"


cat > $ROOT/scripts/guardian/api-route-map.json <<EOF
{
 "service":"eaasgrid-api",
 "base_url":"http://192.168.100.21:4000",
 "discovered":"$(date)",
 "health_candidates":[
 "/health",
 "/api/health",
 "/api/v1/health"
 ],
 "auth_endpoint":"/api/v1/auth/login"
}
EOF


echo "[PASS] API route map created"


echo
echo "============================================"
echo "COMPLETE"
echo "REPORT:"
echo "$REPORT"
echo "============================================"

