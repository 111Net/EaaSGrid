const express = require("express");

const router = express.Router();


const authenticate =
require("../middleware/auth");


const requirePermission =
require("../middleware/permission");



router.get(
"/summary",

authenticate,

requirePermission("VIEW_DASHBOARD"),


(req,res)=>{


res.json({

platformStatus:"Operational",

totalSites:6,

activeCustomers:0,

monthlyRevenue:0,

energyGenerated:"0 kWh",

uptime:"99.9%",

timestamp:new Date()

});


});


module.exports = router;
