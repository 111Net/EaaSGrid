
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

warehouse:"XaaSGrid Data Intelligence",
status:"ready"

});

});


module.exports=router;

