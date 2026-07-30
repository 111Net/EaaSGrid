#!/bin/bash

set -e

API=/data/eaasgrid-platform/apps/api

echo "======================================"
echo " XaaSGrid Dashboard Compatibility Fix"
echo "======================================"

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


const totalSites =
devices.rows[0].count;


const generated =
Number(energy.rows[0].energy || 0);


const revenue =
Number(energy.rows[0].revenue || 0);


return {


platform:{
name:"XaaSGrid",
version:"3.0.0",
environment:"development",
server_time:new Date()
},


company:{
name:"EaaSGrid Energy Services",
headquarters:"Ibadan, Oyo State, Nigeria",
project:"Everything-as-a-Service Platform"
},


dashboard:{
status:"Operational",
last_updated:new Date()
},


infrastructure:{
pilot_sites:6,
planned_sites_per_year:60,
active_sites:totalSites,
monitored_sites:totalSites
},


investment:{
required_capital_ngn:298000000,
currency:"NGN",
funding_stage:"Pilot Deployment"
},


energy:{
monthly_generation:generated/1000,
battery_utilisation:100,
connected_assets:totalSites
},


finance:{
monthly_revenue:revenue,
portfolio_value:Number(
ledger.rows[0].portfolio || 0
)
},


performance:{
availability:100,
maintenance_alerts:0
},


sites:[],


business_model:"Everything-as-a-Service",


target_markets:[
"Nigeria",
"Commercial",
"Industrial",
"Healthcare",
"Education"
]

};


}


module.exports={
getDashboardData
};
EOF


echo "Restarting API"

pkill -f "node src/server.js" || true

sleep 3

cd $API

nohup npm start >/tmp/eaasgrid-api.log 2>&1 &


sleep 8


echo "Testing API"

curl -s http://192.168.100.21:4000/api/v1/dashboard | jq '.data.dashboard,.data.infrastructure,.data.finance'


echo ""
echo "======================================"
echo " Compatibility Fix Complete"
echo "======================================"
