

const express = require("express");

const router = express.Router();



const roles = [

"ADMIN",

"OPERATOR",

"FINANCE",

"CUSTOMER"

];



const permissions = [

"users.read",

"users.write",

"billing.read",

"billing.write",

"tenant.manage",

"organization.manage"

];



router.get("/roles",(req,res)=>{


res.json({

success:true,

roles

});


});



router.get("/permissions",(req,res)=>{


res.json({

success:true,

permissions

});


});



module.exports = router;

