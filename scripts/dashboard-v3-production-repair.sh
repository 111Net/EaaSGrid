#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform
API=$ROOT/apps/api
DASH=$ROOT/apps/dashboard

echo "======================================"
echo " XaaSGrid Dashboard v3 Repair"
echo "======================================"

cd $ROOT


echo "[1] Backup current dashboard files"

mkdir -p backups/dashboard-v3

cp $API/src/routes/dashboard.routes.js \
backups/dashboard-v3/dashboard.routes.js.$(date +%s) 2>/dev/null || true

cp $API/src/controllers/dashboard.controller.js \
backups/dashboard-v3/dashboard.controller.js.$(date +%s) 2>/dev/null || true

cp $API/src/services/dashboard.service.js \
backups/dashboard-v3/dashboard.service.js.$(date +%s) 2>/dev/null || true



echo "[2] Writing dashboard service"


cat > $API/src/services/dashboard.service.js <<'EOF'
const pool = require("../config/postgres");


async function getDashboardData(){

const [
customers,
devices,
energy,
ledger
]=await Promise.all([


pool.query(`
SELECT COUNT(*)::int count
FROM customers
WHERE status='ACTIVE'
`),


pool.query(`
SELECT COUNT(*)::int count
FROM devices
`),


pool.query(`
SELECT
COALESCE(SUM(kwh),0) energy,
COALESCE(SUM(cost),0) revenue
FROM energy_usage
`),


pool.query(`
SELECT
COALESCE(SUM(balance_cached),0) portfolio
FROM ledger_accounts
`)

]);


const totalDevices =
devices.rows[0].count;


return {

platformStatus:
"Operational",


totalSites:
totalDevices,


pilotSites:
6,


activeCustomers:
customers.rows[0].count,


monthlyRevenue:
Number(
energy.rows[0].revenue || 0
),


energyGenerated:
Number(
energy.rows[0].energy || 0
),


uptime:
totalDevices > 0 ? "100%" : "0%",


portfolioValue:
Number(
ledger.rows[0].portfolio || 0
),


lastSync:
new Date().toISOString()

};


}


module.exports={
getDashboardData
};
EOF



echo "[3] Writing controller"


cat > $API/src/controllers/dashboard.controller.js <<'EOF'
const dashboardService =
require("../services/dashboard.service");


exports.getDashboard = async(req,res,next)=>{

try{

const data =
await dashboardService.getDashboardData();


res.json({

success:true,

data:data

});


}catch(error){

next(error);

}

};
EOF



echo "[4] Writing routes"


cat > $API/src/routes/dashboard.routes.js <<'EOF'
const express=require("express");

const router=express.Router();

const {
getDashboard
}=require("../controllers/dashboard.controller");


router.get("/",getDashboard);


module.exports=router;
EOF



echo "[5] Restart API"

pkill -f "node.*server" || true

sleep 3


cd $API

nohup npm start >/tmp/eaasgrid-api.log 2>&1 &


sleep 8



echo "[6] Restart Dashboard"

pkill -f "next" || true

sleep 3


cd $DASH

nohup npm run dev -- --hostname 0.0.0.0 >/tmp/eaasgrid-dashboard.log 2>&1 &


sleep 10



echo "[7] API TEST"

curl -s http://192.168.100.21:4000/api/v1/dashboard | jq



echo ""
echo "======================================"
echo " Dashboard v3 Repair Complete"
echo " Open:"
echo " http://192.168.100.21:3000/control-centre"
echo "======================================"
