
const express=require("express");


const router=express.Router();



router.get("/recommendations",(req,res)=>{


res.json({

success:true,

recommendations:[

"Monitor customer growth",

"Review platform utilisation"

]


});


});


module.exports=router;

