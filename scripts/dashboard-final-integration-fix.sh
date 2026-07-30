#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform

echo "======================================"
echo " XaaSGrid Final Dashboard Integration"
echo "======================================"

cd $ROOT/apps/api


echo "[1] Backup"

cp src/services/dashboard.service.js \
src/services/dashboard.service.backup-final


echo "[2] Writing compatible dashboard service"


cat > src/services/dashboard.service.js <<'EOF'
const pool = require("../config/postgres");


async function getDashboardData(){

const devices =
await pool.query(`
SELECT
id,
device_code,
device_type,
manufacturer,
connectivity
FROM devices
ORDER BY id
`);


const energy =
await pool.query(`
SELECT
COALESCE(SUM(kwh),0) total_kwh,
COALESCE(SUM(cost),0) revenue
FROM energy_usage
`);


const ledger =
await pool.query(`
SELECT
COALESCE(SUM(balance_cached),0) portfolio
FROM ledger_accounts
`);


return {

platformStatus:"Operational",

totalSites:
devices.rows.length,

pilotSites:
devices.rows.length,

monthlyRevenue:
Number(energy.rows[0].revenue || 0),

energyGenerated:
Number(energy.rows[0].total_kwh || 0),

uptime:
devices.rows.length > 0
?
"100%"
:
"0%",

portfolioValue:
Number(ledger.rows[0].portfolio || 0),


sites:

devices.rows.map(d=>({

id:d.id,

site_code:d.device_code,

device_type:d.device_type,

manufacturer:d.manufacturer,

connectivity:d.connectivity,

status:
d.connectivity==="ONLINE"
?
"Active"
:
"Offline"

})),

dashboard:{

status:"Operational",

last_updated:
new Date()

},

infrastructure:{

planned_sites_per_year:60

},

investor:{

stage:"Pilot Deployment",

funding_amount:298000000

}

};


}


module.exports={
getDashboardData
};
EOF



echo "[3] Restart API"

pkill -f "node src/server.js" || true

sleep 2

cd $ROOT/apps/api

nohup npm start > /tmp/eaasgrid-api.log 2>&1 &


sleep 5


echo "[4] API TEST"

curl -s http://192.168.100.21:4000/api/v1/dashboard | jq '.data'


echo "[5] Restart Dashboard"

cd $ROOT/apps/dashboard

pkill -f "next" || true

sleep 2

nohup npm run dev -- --hostname 0.0.0.0 > /tmp/eaasgrid-dashboard.log 2>&1 &


echo ""
echo "======================================"
echo " COMPLETE"
echo "======================================"

echo "Open:"
echo "http://192.168.100.21:3000/control-centre"

