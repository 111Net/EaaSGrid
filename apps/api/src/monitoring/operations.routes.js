
const express=require("express");

const router=express.Router();


router.get("/overview",(req,res)=>{

res.json({

platform:"XaaSGrid",
devices:0,
alerts:0,
status:"operational"

});

});


module.exports=router;

