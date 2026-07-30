
const express=require("express");

const router=express.Router();


router.get("/dashboard",(req,res)=>{

res.json({

portal:"investor",

status:"ready"

});

});


module.exports=router;

