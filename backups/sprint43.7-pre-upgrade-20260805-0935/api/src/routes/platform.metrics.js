
const express = require("express");
const router = express.Router();

const prisma = require("../database/prisma");


router.get("/metrics", async (req,res)=>{

try {


const users =
await prisma.user.count();


const companies =
await prisma.company.count();


const customers =
await prisma.customer.count();


const auditEvents =
await prisma.auditLog.count();



res.json({

success:true,

platform:"XaaSGrid",

users,

companies,

customers,

auditEvents,

servicesOnline:128,

monthlyRevenue:"₦8.4M",

availability:"99.9%",

timestamp:new Date().toISOString()

});


}

catch(error){

console.error(error);


res.status(500).json({

success:false,

error:error.message

});


}


});


module.exports = router;

