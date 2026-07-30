
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

automation:"enabled",
jobs:0,
status:"ready"

});

});


router.post("/execute",(req,res)=>{

res.json({

success:true,
message:"Automation workflow queued"

});

});


module.exports=router;

