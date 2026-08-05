

const express = require("express");

const router = express.Router();



let tenants = [

{
id:"tenant-demo",
name:"Default Tenant",
status:"ACTIVE"
}

];



router.get("/",(req,res)=>{


res.json({

success:true,

tenants

});


});




router.post("/",(req,res)=>{


const tenant = {

id:"tenant-"+Date.now(),

name:req.body.name || "New Tenant",

status:"ACTIVE"

};



tenants.push(tenant);



res.json({

success:true,

tenant

});


});



module.exports = router;

