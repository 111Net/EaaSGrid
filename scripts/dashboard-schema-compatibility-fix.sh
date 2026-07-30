#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform/apps/api

echo "======================================"
echo " XaaSGrid Dashboard Schema Compatibility"
echo "======================================"

cd $ROOT

cp src/services/dashboard.service.js \
src/services/dashboard.service.before-compat.js


python3 <<'PY'

from pathlib import Path

p=Path("src/services/dashboard.service.js")

text=p.read_text()

text=text.replace(
'return {',
'''
return {

finance:{
 monthly_revenue:
 Number(energy.rows[0].revenue || 0),

 portfolio_value_ngn:
 Number(ledger.rows[0].portfolio || 0)
},

energy:{
 monthly_generation_mwh:
 Number(energy.rows[0].total_kwh || 0)/1000,

 battery_utilisation_percent:100,

 connected_assets:
 devices.rows.length
},

performance:{
 availability_percent:
 devices.rows.length > 0 ? 100 : 0,

 maintenance_alerts:0
},

'''
)

text=text.replace(
'platformStatus:"Operational",',
'''
platform:{
 name:"XaaSGrid",
 version:"3.0.0",
 environment:"development",
 server_time:new Date()
},

platformStatus:"Operational",
'''
)


text=text.replace(
'pilotSites:',
'''
infrastructure:{
 pilot_sites:
 devices.rows.length,

 planned_sites_per_year:60
},

pilotSites:
'''
)


text=text.replace(
'portfolioValue:',
'''
dashboard:{
 status:"Operational",
 last_updated:new Date()
},

portfolioValue:
'''
)

p.write_text(text)

PY


echo "[1] Restart API"

pkill -f "node src/server.js" || true

sleep 2

cd $ROOT

nohup npm start >/tmp/eaasgrid-api.log 2>&1 &


sleep 5


echo "[2] API verification"

curl -s http://192.168.100.21:4000/api/v1/dashboard | jq '.data.finance,.data.energy,.data.performance'


echo "======================================"
echo " COMPLETE"
echo "======================================"

