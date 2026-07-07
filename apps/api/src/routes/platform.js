const express = require("express");

const router = express.Router();

router.get("/status", (req, res) => {

    res.json({
        platform: "EaaSGrid",
        status: "operational",
        version: "1.0"
    });

});

module.exports = router;
