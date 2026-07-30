#!/bin/bash

set -e

echo "=========================================="
echo " XaaSGrid Sprint 1 Final Route Repair"
echo " Route Ordering Correction"
echo "=========================================="

ROOT="/data/eaasgrid-platform"

cd "$ROOT"


APP="apps/api/src/app.js"


echo ""
echo "[1] Backing up app.js"

cp "$APP" "$APP.backup-$(date +%Y%m%d-%H%M%S)"



echo ""
echo "[2] Removing misplaced Sprint 1 routes"


python3 <<'PY'

from pathlib import Path

file = Path("apps/api/src/app.js")

text = file.read_text()


marker = "// =====================================\n// Sprint 1 Commercial Platform Routes"


if marker in text:
    text = text.split(marker)[0].rstrip()


file.write_text(text)

PY



echo ""
echo "[3] Inserting Sprint 1 routes before error handler"


python3 <<'PY'

from pathlib import Path

file = Path("apps/api/src/app.js")

text=file.read_text()


insert=r'''

/*
|--------------------------------------------------------------------------
| Sprint 1 Commercial Platform Routes
|--------------------------------------------------------------------------
*/

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


'''


target="app.use(notFound);"


text=text.replace(
target,
insert+target
)


file.write_text(text)

PY



echo ""
echo "[4] Restarting API"


pkill -f "node src/server.js" || true

cd apps/api

nohup npm start > api-runtime.log 2>&1 &


sleep 5



echo ""
echo "[5] Testing routes"


echo ""

echo "Customer:"
curl -s http://localhost:4000/api/v1/customer


echo ""

echo "Subscription:"
curl -s http://localhost:4000/api/v1/subscription


echo ""

echo "Billing:"
curl -s http://localhost:4000/api/v1/billing


echo ""

echo "Partner:"
curl -s http://localhost:4000/api/v1/partner


echo ""

echo "Investor:"
curl -s http://localhost:4000/api/v1/investor


echo ""

echo "Monitoring:"
curl -s http://localhost:4000/api/v1/monitoring



echo ""

echo "=========================================="
echo " Sprint 1 Route Repair Completed"
echo "=========================================="
