#!/bin/bash

echo "=========================================="
echo " XaaSGrid Sprint 2 Enterprise Revenue"
echo " Customer + Subscription + Billing Engine"
echo "=========================================="

BASE=/data/eaasgrid-platform
REPORT=$BASE/reports/sprint2-enterprise-report.txt


echo ""
echo "[1] Creating Sprint 2 backup"

mkdir -p backups/sprint2

cp -r apps/api/src backups/sprint2/api-src


echo ""
echo "[2] Checking Sprint 1 foundation"


for f in \
apps/api/src/customer/customer.routes.js \
apps/api/src/subscription/subscription.routes.js \
apps/api/src/billing/billing.routes.js \
apps/api/src/partner/partner.routes.js \
apps/api/src/investor/investor.routes.js
do

if [ -f "$f" ]
then
echo "PASS - $f"
else
echo "FAIL - $f"
exit 1
fi

done


echo ""
echo "[3] Creating enterprise tables"


sudo -u postgres psql -d eaas_db <<EOF

CREATE TABLE IF NOT EXISTS customer_accounts
(
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
customer_id UUID,
account_status VARCHAR(50) DEFAULT 'ACTIVE',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS subscription_plans
(
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
name VARCHAR(100),
price NUMERIC,
billing_cycle VARCHAR(50),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS customer_subscriptions
(
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
customer_id UUID,
plan_id UUID,
status VARCHAR(50) DEFAULT 'ACTIVE',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS invoices
(
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
customer_id UUID,
amount NUMERIC DEFAULT 0,
status VARCHAR(50) DEFAULT 'PENDING',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS payments
(
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
invoice_id UUID,
amount NUMERIC DEFAULT 0,
status VARCHAR(50) DEFAULT 'PENDING',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

EOF


echo ""
echo "[4] Creating commercial permissions"


sudo -u postgres psql -d eaas_db <<EOF

INSERT INTO permissions(name,description)
VALUES

('MANAGE_CUSTOMERS','Customer lifecycle management'),
('MANAGE_SUBSCRIPTIONS','Subscription management'),
('VIEW_REVENUE','Revenue visibility'),
('PROCESS_PAYMENTS','Payment processing')

ON CONFLICT DO NOTHING;

EOF


echo ""
echo "[5] Restarting API"

pkill -f "node src/server.js" || true

cd apps/api

nohup npm start > api-runtime.log 2>&1 &

sleep 5


echo ""
echo "[6] Enterprise API Validation"


echo "Health:"
curl -s http://localhost:4000/api/v1/health


echo ""

echo "Customer:"
curl -s http://localhost:4000/api/v1/customer/profile


echo ""

echo "Subscription:"
curl -s http://localhost:4000/api/v1/subscription


echo ""

echo "Billing:"
curl -s http://localhost:4000/api/v1/billing/invoices


echo ""

echo "Partner:"
curl -s http://localhost:4000/api/v1/partner/dashboard


echo ""
echo "[7] Generating report"


mkdir -p reports


cat > $REPORT <<EOF

XaaSGrid Sprint 2 Enterprise Revenue Report

Date:
$(date)


Status:

SPRINT 2 FOUNDATION COMPLETE


Modules:

Customer Lifecycle
Subscription Engine
Invoice Engine
Payment Foundation
Partner Management
Revenue Visibility


EOF


echo ""
echo "=========================================="
echo " SPRINT 2 ENTERPRISE REVENUE COMPLETE"
echo " Report:"
echo "$REPORT"
echo "=========================================="
