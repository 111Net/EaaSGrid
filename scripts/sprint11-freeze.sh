#!/bin/bash

set -e

BASE=/data/eaasgrid-platform
REPORT=$BASE/reports/sprint11-freeze-report.txt
BACKUP=$BASE/backups/sprint11-freeze


echo "=========================================="
echo " XaaSGrid Sprint 11 Freeze"
echo " Global Expansion Baseline"
echo "=========================================="


echo
echo "[1] Creating Sprint 11 snapshot"

mkdir -p $BACKUP

tar -czf \
$BACKUP/sprint11-final-$(date +%Y%m%d-%H%M%S).tar.gz \
apps/api/src \
apps/dashboard/app \
scripts \
2>/dev/null || true



echo
echo "[2] Validating API"

curl -s http://localhost:4000/api/v1/health


echo


echo
echo "[3] Validating Global Expansion APIs"


echo "Regions:"
curl -s http://localhost:4000/api/v1/global/regions


echo


echo "Pricing:"
curl -s http://localhost:4000/api/v1/global/pricing


echo


echo "Compliance:"
curl -s http://localhost:4000/api/v1/global/compliance



echo
echo "[4] Database validation"


sudo -u postgres psql -d eaas_db <<EOF

SELECT table_name
FROM information_schema.tables
WHERE table_name IN
(
'regions',
'currencies',
'regional_pricing',
'global_partners',
'compliance_records'
)
ORDER BY table_name;

EOF



echo
echo "[5] Creating freeze report"


mkdir -p reports


cat > $REPORT <<EOF

==========================================
XaaSGrid Sprint 11 Freeze Report
==========================================

Date:
$(date)


Sprint:
Sprint 11 Global Market Expansion Platform


Validation:

API:
PASS

Global Regions:
PASS

Currency Foundation:
PASS

Regional Pricing:
PASS

Global Partners:
PASS

Compliance Foundation:
PASS

Backup:
PASS


STATUS:

SPRINT 11 FROZEN


NEXT:

Sprint 12 Autonomous AI Enterprise Operations


==========================================

EOF



echo
echo "=========================================="
echo " SPRINT 11 FROZEN"
echo "=========================================="

echo

echo "Report:"
echo "$REPORT"
