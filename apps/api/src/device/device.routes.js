
const express=require("express");

const router=express.Router();


router.get("/list",(req,res)=>{

res.json({

devices:[],
status:"ready"

});

});


module.exports=router;

