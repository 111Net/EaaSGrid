
const express=require("express");

const router=express.Router();


router.get("/invoices",(req,res)=>{

res.json({

invoices:[]

});

});


module.exports=router;

