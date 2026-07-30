
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

mobile:"XaaSGrid Mobile Platform",
status:"foundation-ready"

});

});


module.exports=router;

