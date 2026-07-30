
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

sla:"99.9%",
status:"compliant"

});

});


module.exports=router;

