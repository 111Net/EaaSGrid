const express=require("express");

const router=express.Router();

const authenticate=
require("../middleware/auth");


router.get(
"/",
authenticate,
(req,res)=>{

res.json({
message:"User management endpoint",
user:req.user
});

});


module.exports=router;
