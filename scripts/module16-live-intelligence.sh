#!/bin/bash

echo "======================================"
echo " XaaSGrid Module 16 Live Intelligence"
echo "======================================"


ROOT="/data/eaasgrid-platform"

cd $ROOT || exit 1


echo "[1] Backup dashboard API files"

mkdir -p backups/module16

cp apps/api/src/services/dashboard.service.js \
backups/module16/dashboard.service.$(date +%F-%H%M).js 2>/dev/null


cp apps/api/src/controllers/dashboard.controller.js \
backups/module16/dashboard.controller.$(date +%F-%H%M).js 2>/dev/null


cp apps/api/src/routes/dashboard.routes.js \
backups/module16/dashboard.routes.$(date +%F-%H%M).js 2>/dev/null



echo "[2] Audit dashboard API wiring"


grep -R "dashboard" apps/api/src/app.js
grep -R "dashboard" apps/api/src/routes/index.js



echo "[3] Backup frontend control centre"


mkdir -p backups/module16/dashboard

cp apps/dashboard/app/control-centre/page.jsx \
backups/module16/dashboard/control-centre.$(date +%F-%H%M).jsx 2>/dev/null



echo "[4] Create frontend dashboard client"


mkdir -p apps/dashboard/lib


cat > apps/dashboard/lib/dashboard.js <<'EOF'

export async function getDashboard(){

const API =
process.env.NEXT_PUBLIC_API_URL ||
"http://localhost:4000";


const response =
await fetch(
`${API}/api/v1/dashboard`,
{
cache:"no-store"
}
);


if(!response.ok){

throw new Error(
"Dashboard API unavailable"
);

}


return response.json();

}

EOF



echo "[5] Validate API package"

cd apps/api

npm run lint 2>/dev/null || true


echo "[6] Validate dashboard package"

cd ../dashboard

npm run lint


if [ $? -ne 0 ]; then

echo "Dashboard lint failed"

exit 1

fi



echo "[7] Build dashboard"

npm run build


echo "======================================"
echo " Module 16 Foundation Completed"
echo "======================================"
