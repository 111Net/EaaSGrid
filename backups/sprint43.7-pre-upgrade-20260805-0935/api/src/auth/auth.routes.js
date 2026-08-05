const express = require("express");

const router = express.Router();


const users = [
{
 id:1,
 email:"admin@xaasgrid.com",
 password:"admin123",
 role:"SUPER_ADMIN"
},

{
 id:2,
 email:"enterprise@xaasgrid.com",
 password:"enterprise123",
 role:"ENTERPRISE_ADMIN"
},

{
 id:3,
 email:"operations@xaasgrid.com",
 password:"operations123",
 role:"OPERATIONS"
}

];


router.post("/login",(req,res)=>{


const {email,password}=req.body;


const user =
users.find(
u =>
u.email===email &&
u.password===password
);



if(!user){

return res.status(401).json({

success:false,

message:"Invalid credentials"

});

}



res.json({

success:true,

token:"xaasgrid-demo-token",

user:{

id:user.id,

email:user.email,

role:user.role

}

});


});


module.exports=router;
