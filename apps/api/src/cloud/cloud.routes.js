
const express=require("express");

const router=express.Router();


router.get("/resources",(req,res)=>{

res.json({

resources:[],
cloud:"global-ready"

});

});


module.exports=router;

