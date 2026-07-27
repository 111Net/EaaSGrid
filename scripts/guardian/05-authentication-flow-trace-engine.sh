#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/auth-flow-trace-$(date +%Y-%m-%d_%H-%M-%S).log"

mkdir -p "$ROOT/reports"

exec > >(tee -a "$REPORT") 2>&1

echo "============================================"
echo " EaaSGrid Authentication Flow Trace Engine"
echo " Module 05"
echo "$(date)"
echo "============================================"


PASS=0
FAIL=0


check()
{
echo
echo "--------------------------------"
echo "$1"
echo "--------------------------------"
}


check "1. Dashboard login component"

if [ -f "$ROOT/apps/dashboard/app/login/page.jsx" ]; then
echo "[PASS] login page exists"
PASS=$((PASS+1))
else
echo "[FAIL] login page missing"
FAIL=$((FAIL+1))
fi


check "2. Authentication client module"

if [ -f "$ROOT/apps/dashboard/lib/auth.js" ]; then

echo "[PASS] auth.js exists"

grep "api/" "$ROOT/apps/dashboard/lib/auth.js"

PASS=$((PASS+1))

else

echo "[FAIL] auth.js missing"
FAIL=$((FAIL+1))

fi



check "3. Detect API login endpoint"

ENDPOINT=$(grep -oE "api/[a-zA-Z0-9/_-]*login" \
"$ROOT/apps/dashboard/lib/auth.js" | head -1)


if [ -n "$ENDPOINT" ]; then

echo "Detected:"
echo "$ENDPOINT"

PASS=$((PASS+1))

else

echo "[FAIL] API endpoint not found"

FAIL=$((FAIL+1))

fi



check "4. API authentication routes"

grep -R "login" \
"$ROOT/apps/api/src" \
--include="*.js" \
| tee /tmp/auth_routes.txt


if grep -q "login" /tmp/auth_routes.txt
then

echo "[PASS] backend login handlers detected"
PASS=$((PASS+1))

else

echo "[FAIL] backend login handlers missing"
FAIL=$((FAIL+1))

fi



check "5. Test API login"

curl -s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}' \
| tee /tmp/login-response.json



if grep -q "token" /tmp/login-response.json
then

echo "[PASS] API returned token"

PASS=$((PASS+1))

else

echo "[FAIL] API login failed"

FAIL=$((FAIL+1))

fi



check "6. Database authentication schema discovery"

echo "Users table columns:"

sudo -u postgres psql eaas_db <<EOF

SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name='users';

EOF



check "7. Frontend session handling"

grep -R "saveSession" \
"$ROOT/apps/dashboard/app" \
"$ROOT/apps/dashboard/lib" \
--exclude-dir=.next



if grep -R "saveSession" \
"$ROOT/apps/dashboard" \
--exclude-dir=.next >/dev/null
then

echo "[PASS] frontend session handler found"
PASS=$((PASS+1))

else

echo "[FAIL] session handler missing"
FAIL=$((FAIL+1))

fi



check "8. Middleware protection"

if [ -f "$ROOT/apps/dashboard/middleware.js" ]
then

echo "[PASS] middleware exists"

grep matcher "$ROOT/apps/dashboard/middleware.js"

PASS=$((PASS+1))

else

echo "[FAIL] middleware missing"
FAIL=$((FAIL+1))

fi



echo
echo "============================================"
echo "SUMMARY"
echo "PASS:$PASS"
echo "FAIL:$FAIL"

if [ "$FAIL" -eq 0 ]
then

echo "STATUS: AUTH PIPELINE HEALTHY"

else

echo "STATUS: INVESTIGATION REQUIRED"

fi


echo
echo "REPORT:"
echo "$REPORT"

echo "============================================"
