#!/bin/bash

echo "================================"
echo " XaaSGrid Safe JSX Repair"
echo "================================"

cd /data/eaasgrid-platform/apps/dashboard || exit 1


echo "[1] Backup current state"

mkdir -p backups/safe-repair

cp app/*/page.jsx backups/safe-repair/ 2>/dev/null
cp app/page.jsx backups/safe-repair/ 2>/dev/null


echo "[2] Fix obvious h1 closing mistakes"


find app -name "page.jsx" -type f | while read file
do

sed -i '
s#Executive Platform Intelligence</div>#Executive Platform Intelligence</h1>#g
s#Analytics Intelligence Centre</div>#Analytics Intelligence Centre</h1>#g
s#Operations Intelligence</div>#Operations Intelligence</h1>#g
s#Security Operations Centre</div>#Security Operations Centre</h1>#g
s#Identity & Access Intelligence</div>#Identity & Access Intelligence</h1>#g
s#Platform Configuration Centre</div>#Platform Configuration Centre</h1>#g
s#Revenue & Billing Intelligence</div>#Revenue & Billing Intelligence</h1>#g
s#Energy Monitoring Centre</div>#Energy Monitoring Centre</h1>#g
' "$file"

done


echo "[3] Remove Next cache"

rm -rf .next


echo "[4] Lint"

npm run lint


echo "[5] Build"

npx next build


echo "================================"
echo " SAFE REPAIR COMPLETE"
echo "================================"
