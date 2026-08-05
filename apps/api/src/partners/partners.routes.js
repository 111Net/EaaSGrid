
const express = require("express");

const router = express.Router();


router.get("/",(req,res)=>{


    res.json({

        success:true,

        module:"partners",

        status:"READY",

        capabilities:[

            "partner-registration",
            "partner-management",
            "partner-services",
            "revenue-sharing"

        ]

    });


});



router.post("/register",(req,res)=>{


    res.json({

        success:true,

        message:"Partner registration enabled"

    });


});


module.exports = router;

