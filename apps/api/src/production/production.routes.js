
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

platform:"XaaSGrid",

environment:"production",

status:"ready"

});

});


module.exports=router;

