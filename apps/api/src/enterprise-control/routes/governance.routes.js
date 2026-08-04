

const express = require("express");

const router = express.Router();



router.get("/audit",(req,res)=>{


res.json({

success:true,

events:[]

});


});



router.get("/security",(req,res)=>{


res.json({

success:true,

securityStatus:"READY"

});


});



module.exports = router;

