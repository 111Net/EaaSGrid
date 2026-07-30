
const express=require("express");

const router=express.Router();


router.get("/partners",(req,res)=>{

res.json({

partners:[],
ecosystem:"ready"

});

});


module.exports=router;

