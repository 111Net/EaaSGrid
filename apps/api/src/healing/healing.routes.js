
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

selfHealing:"enabled",
actions:0,
status:"ready"

});

});


router.post("/repair",(req,res)=>{

res.json({

success:true,
message:"Healing workflow initiated"

});

});


module.exports=router;

