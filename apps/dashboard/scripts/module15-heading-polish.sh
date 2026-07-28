#!/bin/bash

echo "======================================"
echo " XaaSGrid Heading Visual Polish"
echo "======================================"

cd /data/eaasgrid-platform/apps/dashboard || exit


echo "[1] Backup pages"

mkdir -p backups/module15-heading

cp app/operations/page.jsx backups/module15-heading/operations.jsx 2>/dev/null
cp app/analytics/page.jsx backups/module15-heading/analytics.jsx 2>/dev/null
cp app/users/page.jsx backups/module15-heading/users.jsx 2>/dev/null
cp app/security/page.jsx backups/module15-heading/security.jsx 2>/dev/null
cp app/settings/page.jsx backups/module15-heading/settings.jsx 2>/dev/null



echo "[2] Replace blurry text shadow styles"


find app \
-name page.jsx \
-exec sed -i \
's/textShadow:"0 2px 4px rgba(0,0,0,0.18)"/textShadow:"0 1px 2px rgba(0,0,0,0.12)"/g' {} \;



echo "[3] Replace dark blurry headings"


find app \
-name page.jsx \
-exec sed -i \
's/color:"#061A40"/color:"#0B1F3A"/g' {} \;



echo "[4] Clear Next cache"

rm -rf .next



echo "[5] Lint"

npm run lint



echo "[6] Build"

npx next build


echo "======================================"
echo " Heading Polish Completed"
echo " Restart dashboard"
echo "======================================"
