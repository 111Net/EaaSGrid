#!/bin/bash

echo "=========================================="
echo " XaaSGrid Sprint 0 Production Readiness"
echo " Validation Gate 0.12 - 0.13"
echo "=========================================="

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/sprint0-go-live-report.txt"

mkdir -p "$ROOT/reports"

DATE=$(date)

{
echo "=========================================="
echo " XaaSGrid Sprint 0 Go-Live Report"
echo " Date: $DATE"
echo "=========================================="
echo ""
} > "$REPORT"


PASS=0
FAIL=0


check()
{

NAME=$1
COMMAND=$2


echo ""
echo "[CHECK] $NAME"


if eval "$COMMAND" >/dev/null 2>&1
then

echo "PASS - $NAME"

echo "PASS - $NAME" >> "$REPORT"

PASS=$((PASS+1))

else

echo "FAIL - $NAME"

echo "FAIL - $NAME" >> "$REPORT"

FAIL=$((FAIL+1))

fi

}


echo ""
echo "[1] Infrastructure"


check "PostgreSQL running" \
"systemctl is-active postgresql"


check "API port 4000" \
"ss -tulpn | grep ':4000'"


check "Dashboard port 3000" \
"ss -tulpn | grep ':3000'"


check "Disk availability" \
"df -h / | awk 'NR==2 {if (\$5 < 90) exit 0; else exit 1}'"



echo ""
echo "[2] API Health"


check "API Health Endpoint" \
"curl -f http://localhost:4000/api/v1/health"



echo ""
echo "[3] Database Foundation"


check "Organisations table" \
"sudo -u postgres psql -d eaas_db -c '\dt organisations'"


check "Organisation users table" \
"sudo -u postgres psql -d eaas_db -c '\dt organisation_users'"


check "Permissions table" \
"sudo -u postgres psql -d eaas_db -c '\dt permissions'"



echo ""
echo "[4] Authentication"


LOGIN=$(curl -s \
-X POST http://localhost:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}')


echo "$LOGIN" | grep -q token

if [ $? -eq 0 ]
then

echo "PASS - ADMIN Login"
echo "PASS - ADMIN Login" >> "$REPORT"
PASS=$((PASS+1))

else

echo "FAIL - ADMIN Login"
echo "FAIL - ADMIN Login" >> "$REPORT"
FAIL=$((FAIL+1))

fi



echo ""
echo "[5] Frontend"


check "Dashboard source exists" \
"test -f apps/dashboard/app/control-centre/page.jsx"


check "Dashboard layout exists" \
"test -f apps/dashboard/components/layout/DashboardLayout.jsx"



echo ""
echo "[6] Backend Modules"


check "Auth service" \
"test -f apps/api/src/auth/auth.service.js"


check "User management foundation" \
"find apps/api/src -type f | grep users"


check "Audit foundation" \
"find apps/api/src -type f | grep audit"



echo ""
echo "=========================================="
echo " RESULT"
echo "=========================================="

echo ""
echo "PASSED : $PASS"
echo "FAILED : $FAIL"

echo ""
echo "Report:"
echo "$REPORT"


{
echo ""
echo "=========================================="
echo "SUMMARY"
echo "PASSED: $PASS"
echo "FAILED: $FAIL"
echo "=========================================="
} >> "$REPORT"


if [ $FAIL -eq 0 ]
then

echo ""
echo "=========================================="
echo " XaaSGRID SPRINT 0 GO-LIVE READY"
echo "=========================================="

exit 0

else

echo ""
echo "=========================================="
echo " XaaSGRID NEEDS REMEDIATION"
echo "=========================================="

exit 1

fi
