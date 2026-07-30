
const express=require("express");

const router=express.Router();


router.get("/regions",(req,res)=>{

res.json({

service:"global-expansion",

regions:[]

});

});


router.get("/pricing",(req,res)=>{

res.json({

pricing_engine:"enabled",

status:"ready"

});

});


router.get("/compliance",(req,res)=>{

res.json({

compliance_framework:"active",

status:"ready"

});

});


module.exports=router;

