#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/session-contract-$(date +%F_%H-%M-%S).log"

mkdir -p "$ROOT/reports"

exec > >(tee -a "$REPORT") 2>&1

echo "============================================"
echo " EaaSGrid Session Contract Integrity Engine"
echo " Module 06"
date
echo "============================================"


FAIL=0


check(){

echo
echo "--------------------------------"
echo "$1"
echo "--------------------------------"

}


check "1. Detect frontend session storage"

grep -R "localStorage.*eaasgrid_token" \
$ROOT/apps/dashboard \
--exclude-dir=.next

if [ $? -eq 0 ]; then
echo "[FOUND] localStorage token storage"
else
echo "[FAIL]"
FAIL=$((FAIL+1))
fi


check "2. Detect middleware session requirement"

grep -R "cookies.get" \
$ROOT/apps/dashboard/middleware.js

if [ $? -eq 0 ]; then
echo "[FOUND] Cookie based middleware"
else
echo "[FAIL]"
FAIL=$((FAIL+1))
fi


check "3. Compare contracts"

echo "
Frontend:
localStorage token

Middleware:
cookie token
"


check "4. Detect cookie setter"

grep -R "cookies.set\|document.cookie" \
$ROOT/apps/dashboard \
--exclude-dir=.next


check "5. Inspect login response handler"

grep -R "saveSession(result)" \
$ROOT/apps/dashboard/app


check "6. Generate repair recommendation"


if grep -R "localStorage.*eaasgrid_token" \
$ROOT/apps/dashboard/lib/auth.js >/dev/null
then

echo "[ISSUE DETECTED]"
echo "Frontend stores token in localStorage"
echo "Middleware requires cookie"
echo "Session contract mismatch"

else

echo "[PASS]"

fi


check "7. Security guardrail"

echo "
NO automatic credential modification.
NO database changes.
NO password changes.
Only session contract repair allowed.
"


echo
echo "============================================"
echo "SUMMARY"
echo "FAILURES:$FAIL"
echo "REPORT:"
echo "$REPORT"
echo "============================================"
