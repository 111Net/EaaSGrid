#!/bin/bash

echo "=========================================="
echo " XaaSGrid Sprint 1 Freeze"
echo " Commercial Platform Baseline"
echo "=========================================="

BASE=/data/eaasgrid-platform
REPORT=$BASE/reports/sprint1-freeze-report.txt

mkdir -p $BASE/reports
mkdir -p $BASE/backups/sprint1-freeze

echo ""
echo "[1] Creating snapshot backup"

cp -r apps/api/src \
backups/sprint1-freeze/api-src

cp -r apps/dashboard/app \
backups/sprint1-freeze/dashboard-app


echo ""
echo "[2] Validating API"

curl -s http://localhost:4000/api/v1/health \
| tee /tmp/api-health


echo ""
echo "[3] Validating commercial services"


echo "Customer:"
curl -s \
http://localhost:4000/api/v1/customer/profile


echo ""

echo "Subscription:"
curl -s \
http://localhost:4000/api/v1/subscription


echo ""

echo "Billing:"
curl -s \
http://localhost:4000/api/v1/billing/invoices


echo ""

echo "Partner:"
curl -s \
http://localhost:4000/api/v1/partner/dashboard


echo ""

echo "Investor:"
curl -s \
http://localhost:4000/api/v1/investor


echo ""

echo "Monitoring:"
curl -s \
http://localhost:4000/api/v1/monitoring/health



echo ""
echo "[4] Database validation"

sudo -u postgres psql -d eaas_db <<EOF

SELECT table_name
FROM information_schema.tables
WHERE table_name IN
(
'customers',
'subscriptions',
'invoices',
'payments',
'organisations',
'permissions'
);

EOF


echo ""
echo "[5] Generating freeze report"


cat > $REPORT <<EOF

XaaSGrid Sprint 1 Freeze Report

Date:
$(date)

Status:

SPRINT 1 COMMERCIAL FOUNDATION FROZEN


Completed:

Customer onboarding
Subscription engine foundation
Billing foundation
Partner portal
Investor portal
Monitoring foundation
Production deployment foundation


Next:

Sprint 2 Enterprise Expansion


EOF


echo ""
echo "=========================================="
echo " SPRINT 1 FROZEN"
echo " Report:"
echo "$REPORT"
echo "=========================================="
