#!/bin/bash

set -e

echo "=========================================="
echo " XaaSGrid Sprint 1 Integration"
echo " Route + Database + Permission Wiring"
echo "=========================================="

ROOT="/data/eaasgrid-platform"

cd "$ROOT" || exit 1


echo ""
echo "[1] Applying commercial database schema"


sudo -u postgres psql -d eaas_db \
-f apps/api/src/database/commercial-schema.sql


echo ""
echo "[2] Adding commercial permissions"


sudo -u postgres psql -d eaas_db <<'SQL'

INSERT INTO permissions(name,description)
VALUES

('VIEW_CUSTOMER_PORTAL',
'Customer portal access'),

('VIEW_PARTNER_PORTAL',
'Partner portal access'),

('VIEW_SUBSCRIPTIONS',
'Subscription management access'),

('VIEW_BILLING_PORTAL',
'Billing access'),

('VIEW_MONITORING',
'Monitoring dashboard access')

ON CONFLICT(name)
DO NOTHING;


SQL


echo ""
echo "[3] Mapping permissions"



sudo -u postgres psql -d eaas_db <<'SQL'


INSERT INTO role_permissions(role_id,permission_id)

SELECT

r.id,
p.id

FROM roles r, permissions p

WHERE r.name='CUSTOMER'
AND p.name='VIEW_CUSTOMER_PORTAL'


ON CONFLICT DO NOTHING;



INSERT INTO role_permissions(role_id,permission_id)

SELECT

r.id,
p.id

FROM roles r, permissions p

WHERE r.name='PARTNER'
AND p.name='VIEW_PARTNER_PORTAL'


ON CONFLICT DO NOTHING;



INSERT INTO role_permissions(role_id,permission_id)

SELECT

r.id,
p.id

FROM roles r, permissions p

WHERE r.name='INVESTOR'
AND p.name='VIEW_MONITORING'


ON CONFLICT DO NOTHING;



INSERT INTO role_permissions(role_id,permission_id)

SELECT

r.id,
p.id

FROM roles r, permissions p

WHERE r.name='ADMIN'


ON CONFLICT DO NOTHING;


SQL



echo ""
echo "[4] Registering API routes"


SERVER="apps/api/src/server.js"


if ! grep -q "customer.routes" "$SERVER"
then


cat >> "$SERVER" <<'EOF'


// Sprint 1 Commercial Routes

app.use(
"/api/v1/customer",
require("./customer/customer.routes")
);


app.use(
"/api/v1/subscription",
require("./subscription/subscription.routes")
);


app.use(
"/api/v1/billing",
require("./billing/billing.routes")
);


app.use(
"/api/v1/partner",
require("./partner/partner.routes")
);


app.use(
"/api/v1/investor",
require("./investor/investor.routes")
);


app.use(
"/api/v1/monitoring",
require("./monitoring/monitoring.routes")
);

EOF


echo "Routes added"

else

echo "Routes already exist"

fi



echo ""
echo "[5] Restarting API"



pkill -f "node src/server.js" || true


cd apps/api

nohup npm start > api-runtime.log 2>&1 &


sleep 5



echo ""
echo "[6] Testing commercial APIs"



curl -s http://localhost:4000/api/v1/customer/profile

echo ""


curl -s http://localhost:4000/api/v1/subscription

echo ""


curl -s http://localhost:4000/api/v1/billing/invoices

echo ""



echo ""
echo "=========================================="
echo " Sprint 1 Integration Complete"
echo "=========================================="
