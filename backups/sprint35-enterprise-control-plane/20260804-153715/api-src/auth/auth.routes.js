
const express=require("express");

const router=express.Router();

const jwt=require("jsonwebtoken");


router.post("/login",(req,res)=>{


const {
email,
password
}=req.body;


if(
email==="admin@xaasgrid.com"
&&
password==="admin123"
)

{

const token=jwt.sign(
{
email,
role:"admin"
},
process.env.JWT_SECRET,
{
expiresIn:"24h"
}
);


return res.json({

success:true,

token,

user:{
email,
role:"admin"
}

});


}


res.status(401).json({

success:false,

message:"Invalid credentials"

});


});


module.exports=router;

