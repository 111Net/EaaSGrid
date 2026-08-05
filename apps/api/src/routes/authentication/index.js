

const express=require("express");

const router=express.Router();

const crypto=require("crypto");


router.post("/login",(req,res)=>{


const {email,password}=req.body;


if(!email || !password){

return res.status(400).json({

success:false,

message:"Email and password required"

});

}



const token=crypto
.randomBytes(32)
.toString("hex");



res.json({

success:true,

token,

user:{

email,

role:"SUPER_ADMIN"

}

});


});


module.exports=router;

