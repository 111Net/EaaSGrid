
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

digitalTwin:"enabled",
assets:0,
status:"ready"

});

});


module.exports=router;

