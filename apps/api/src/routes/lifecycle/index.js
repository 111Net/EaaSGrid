
const express=require("express");

const router=express.Router();


router.get("/",(req,res)=>{

res.json({

success:true,

services:[

{
client:"GreenGrid Infrastructure Africa",
service:"Solar-as-a-Service",
stage:"OPERATE"
},

{
client:"NovaSecure Technologies",
service:"Managed Security",
stage:"MONITOR"
}

]

});

});


module.exports=router;

