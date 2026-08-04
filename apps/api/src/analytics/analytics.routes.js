
const express = require("express");

const router = express.Router();


router.get("/overview",(req,res)=>{


res.json({

success:true,

platform:"XaaSGrid Analytics Engine",

metrics:{

users:1,

companies:0,

customers:0,

availability:"99.9%"

},

status:"READY"

});


});



router.get("/usage",(req,res)=>{


res.json({

success:true,

usage:[]

});


});


router.get("/health",(req,res)=>{


res.json({

success:true,

analytics:"operational"

});


});


module.exports = router;

