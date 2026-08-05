
const express = require("express");

const router = express.Router();


router.get("/", (req,res)=>{

    res.json({

        success:true,

        module:"marketplace",

        status:"READY",

        capabilities:[

            "service-catalogue",
            "product-listings",
            "subscriptions",
            "partner-offers"

        ]

    });

});



router.get("/catalog",(req,res)=>{


    res.json({

        success:true,

        catalogue:[

            {
                name:"XaaSGrid Solar Platform",
                category:"Energy"
            },

            {
                name:"AI Operations Platform",
                category:"Artificial Intelligence"
            },

            {
                name:"Security Automation Platform",
                category:"Cybersecurity"
            }

        ]

    });


});


module.exports = router;

