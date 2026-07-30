
const express=require("express");

const router=express.Router();


router.get("/recommendations",(req,res)=>{

res.json({

recommendations:[],
optimisation:"enabled"

});

});


module.exports=router;

