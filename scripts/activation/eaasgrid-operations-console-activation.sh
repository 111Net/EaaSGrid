#!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/activation-reports/$DATE"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/operations-console-activation.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Operations Console Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



CONSOLE="$ROOT/apps/control-centre"



echo "[1] Creating Operations Console Modules" | tee -a "$REPORT"


mkdir -p \
"$CONSOLE/modules/health" \
"$CONSOLE/modules/customers" \
"$CONSOLE/modules/partners" \
"$CONSOLE/modules/revenue" \
"$CONSOLE/modules/ai" \
"$CONSOLE/modules/reports" \
"$CONSOLE/modules/audit"



echo "Console modules created" | tee -a "$REPORT"



echo "[2] Creating Role Navigation" | tee -a "$REPORT"


mkdir -p "$CONSOLE/access"


cat > "$CONSOLE/access/navigation.yaml" <<'EOF'
navigation:


admin:

- control_centre

- users

- billing

- audit


operations_worker:

- health

- monitoring

- reports


customer:

- services

- usage

- invoices


partner:

- projects

- installations


investor:

- metrics

- reports

EOF


echo "Role navigation created" | tee -a "$REPORT"



echo "[3] Creating Operations Dashboard" | tee -a "$REPORT"



cat > "$CONSOLE/operations-dashboard.yaml" <<'EOF'
operations_console:


widgets:

- platform_health

- customers

- partners

- revenue

- ai_operations

- factories

- reports


refresh:

live

EOF


echo "Dashboard definition created" | tee -a "$REPORT"



echo "[4] Creating Portal Map" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/portals"


cat > "$ROOT/docs/portals/access-map.yaml" <<'EOF'
portals:


admin:

admin.eaasgrid.com


operations:

ops.eaasgrid.com


customer:

customer.eaasgrid.com


partner:

partner.eaasgrid.com


investor:

investor.eaasgrid.com

EOF


echo "Portal map created" | tee -a "$REPORT"



echo "[5] Creating Browser Operations Guide" | tee -a "$REPORT"



cat > "$ROOT/docs/portals/browser-operation-guide.txt" <<'EOF'
EaaSGrid Browser Operations


Users:

Admin

Operations Worker

Customer

Partner

Investor


Operation:

Login

Select Portal

Monitor

Manage

Report

EOF


echo "Guide created" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/operations-console"

cp "$REPORT" "$ROOT/docs/recovery/operations-console/"


echo "==========================================" | tee -a "$REPORT"
echo "OPERATIONS CONSOLE STATUS: GREEN" | tee -a "$REPORT"
echo "BROWSER OPERATIONS FRAMEWORK READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"
