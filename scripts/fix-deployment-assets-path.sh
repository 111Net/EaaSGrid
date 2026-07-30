#!/bin/bash

set -e

FILE="/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx"

cp "$FILE" "$FILE.backup-assets-path-$(date +%F-%H%M%S)"

python3 <<'PY'

from pathlib import Path

p = Path("/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx")

text = p.read_text()


text = text.replace(
"dashboard.sites.map(site=>(",
"(dashboard.sites || data.sites || []).map(site=>("
)


p.write_text(text)

print("Deployment assets path corrected")

PY


cd /data/eaasgrid-platform/apps/dashboard

npm run build

pkill -f "next" || true

sleep 2

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo "======================================"
echo " Deployment Assets path fixed"
echo " Reload:"
echo " http://192.168.100.21:3000/control-centre"
echo "======================================"
