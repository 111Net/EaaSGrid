#!/bin/bash

echo "======================================"
echo " XaaSGrid Module 16B Live Control Centre"
echo "======================================"


ROOT="/data/eaasgrid-platform"

cd $ROOT || exit 1


echo "[1] Backup Control Centre"

mkdir -p backups/module16b

cp apps/dashboard/app/control-centre/page.jsx \
backups/module16b/control-centre-$(date +%F-%H%M).jsx



echo "[2] Backup dashboard connector"

cp apps/dashboard/lib/dashboard.js \
backups/module16b/dashboard-client-$(date +%F-%H%M).js 2>/dev/null



echo "[3] Check API endpoint"

echo "Current dashboard connector:"
cat apps/dashboard/lib/dashboard.js



echo "[4] Validate dashboard"

cd apps/dashboard

npm run lint


echo "[5] Build test"

npm run build



echo "======================================"
echo " Module 16B Validation Complete"
echo "======================================"
