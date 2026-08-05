

const express = require("express");

const router = express.Router();



router.get("/",(req,res)=>{


res.json({

    success:true,

    module:"developer-api",

    status:"READY",

    version:"v1",

    features:[

        "api-keys",
        "webhooks",
        "integration-api",
        "usage-monitoring"

    ]

});


});



router.get("/documentation",(req,res)=>{


res.json({

success:true,

documentation:"XaaSGrid Developer API"

});


});



module.exports = router;

