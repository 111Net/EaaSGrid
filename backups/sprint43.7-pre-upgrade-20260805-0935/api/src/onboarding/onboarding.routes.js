
const express = require("express");

const router = express.Router();



router.get("/status",(req,res)=>{


res.json({

success:true,

onboarding:"READY",

steps:[

"Account Creation",

"Tenant Provisioning",

"Subscription Activation",

"Customer Setup"

]


});


});



router.post("/trial",(req,res)=>{


res.json({

success:true,

message:"Trial onboarding initialized",

status:"PENDING"

});


});


router.get("/checklist",(req,res)=>{


res.json({

success:true,

checklist:[

"Create account",

"Verify organization",

"Select service plan",

"Activate subscription"

]


});


});


module.exports = router;

