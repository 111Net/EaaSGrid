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
