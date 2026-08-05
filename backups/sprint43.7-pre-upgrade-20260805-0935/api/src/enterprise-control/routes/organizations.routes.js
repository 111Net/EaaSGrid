
const express = require("express");

const router = express.Router();



let organizations = [

{
id:"demo-org",
name:"XaaSGrid Demo Enterprise",
status:"ACTIVE"
}

];



router.get("/",(req,res)=>{

res.json({

success:true,

organizations

});

});



router.post("/",(req,res)=>{


const organization = {

id:"org-"+Date.now(),

name:req.body.name || "New Organization",

status:"ACTIVE"

};


organizations.push(organization);



res.json({

success:true,

organization

});


});



module.exports = router;

