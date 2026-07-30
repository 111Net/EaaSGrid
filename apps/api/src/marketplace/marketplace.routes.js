
const express=require("express");

const router=express.Router();


router.get("/services",(req,res)=>{

res.json({

services:[],
status:"ready"

});

});


module.exports=router;

