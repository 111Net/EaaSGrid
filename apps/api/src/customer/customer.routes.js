
const express=require("express");

const router=express.Router();


router.get("/profile",(req,res)=>{

res.json({

service:"customer",

status:"active"

});

});


module.exports=router;

