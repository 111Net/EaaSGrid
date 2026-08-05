
const express=require("express");

const router=express.Router();


router.get("/",(req,res)=>{

res.json({

success:true,

platform:"XaaSGrid",

description:
"Enterprise XaaS orchestration platform",

modules:[

"Authentication",

"Billing",

"Analytics",

"Operations",

"Intelligence",

"Lifecycle Management"

],

architecture:{

frontend:"Next.js",

backend:"Node.js Express",

database:"PostgreSQL",

cache:"Redis"

}

});

});


module.exports=router;

