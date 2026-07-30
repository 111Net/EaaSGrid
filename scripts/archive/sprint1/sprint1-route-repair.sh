#!/bin/bash

set -e

echo "=========================================="
echo " XaaSGrid Sprint 1 Route Repair"
echo " Express Route Registration Fix"
echo "=========================================="

ROOT="/data/eaasgrid-platform"

cd "$ROOT" || exit 1


APP="apps/api/src/app.js"


echo ""
echo "[1] Checking existing Sprint 1 routes"


if grep -q "customer.routes" "$APP"
then

echo "Sprint 1 routes already registered"

else


echo "Adding Sprint 1 routes"


cat >> "$APP" <<'EOF'


// =====================================
// Sprint 1 Commercial Platform Routes
// =====================================


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


fi



echo ""
echo "[2] Restarting API"


pkill -f "node src/server.js" || true


cd apps/api

nohup npm start > api-runtime.log 2>&1 &


sleep 5



echo ""
echo "[3] Testing Sprint 1 APIs"


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

echo "Investor:"
curl -s http://localhost:4000/api/v1/investor/dashboard

echo ""

echo "Monitoring:"
curl -s http://localhost:4000/api/v1/monitoring/health


echo ""

echo "=========================================="
echo " Sprint 1 Route Repair Complete"
echo "=========================================="
