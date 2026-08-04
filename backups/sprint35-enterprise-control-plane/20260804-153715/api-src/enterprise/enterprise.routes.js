
const express = require("express");

const router = express.Router();


router.get("/organizations", async(req,res)=>{

res.json({

success:true,

organizations:[

{
id:"demo-org",
name:"XaaSGrid Demo Enterprise"
}

]

});

});


router.get("/tenants", async(req,res)=>{

res.json({

success:true,

tenants:[

{
id:"tenant-demo",
name:"Default Tenant",
status:"ACTIVE"
}

]

});

});


router.get("/roles", async(req,res)=>{

res.json({

success:true,

roles:[

"ADMIN",
"OPERATOR",
"FINANCE",
"CUSTOMER"

]

});

});


router.get("/audit", async(req,res)=>{

res.json({

success:true,

events:[]

});

});


module.exports = router;

