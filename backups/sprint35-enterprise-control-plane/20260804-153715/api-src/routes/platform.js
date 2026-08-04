const express = require("express");

const router = express.Router();


router.get("/status", (req, res) => {


    res.json({

        platform: "XaaSGrid",

        status: "operational",

        version: "1.0.0",

        environment:
            process.env.NODE_ENV || "development",

        timestamp: new Date()

    });


});

router.get("/metrics", async (req,res)=>{
    res.json({
        success:true,
        metrics:{
            services:0,
            customers:0,
            companies:0,
            users:0
        }
    });
});
module.exports = router;
