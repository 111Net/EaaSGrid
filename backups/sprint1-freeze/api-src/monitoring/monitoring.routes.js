
const express=require("express");

const router=express.Router();


router.get("/health",(req,res)=>{

res.json({

platform:"XaaSGrid",

status:"operational"

});

});


module.exports=router;

