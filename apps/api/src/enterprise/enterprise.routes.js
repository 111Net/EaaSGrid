
const express=require("express");

const router=express.Router();


router.get("/accounts",(req,res)=>{

res.json({

service:"enterprise",

accounts:[]

});

});


router.get("/pipeline",(req,res)=>{

res.json({

pipeline:[],

status:"active"

});

});


router.get("/sla",(req,res)=>{

res.json({

sla_monitoring:"enabled",

status:"ready"

});

});


module.exports=router;

