
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

backup:"enabled",
recovery:"ready"

});

});


module.exports=router;

