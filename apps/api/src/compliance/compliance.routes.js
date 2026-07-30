
const express=require("express");

const router=express.Router();


router.get("/status",(req,res)=>{

res.json({

compliance:"automated",
frameworks:[],
status:"ready"

});

});


module.exports=router;

