
const express=require("express");

const router=express.Router();


router.get("/list",(req,res)=>{

res.json({

integrations:[],
status:"ready"

});

});


module.exports=router;

