

const express = require("express");

const router = express.Router();



router.get("/overview",(req,res)=>{


res.json({

success:true,

platform:"XaaSGrid Enterprise Control Plane",

status:"READY"

});


});



router.use(
"/",
require("./routes")
);



module.exports = router;

