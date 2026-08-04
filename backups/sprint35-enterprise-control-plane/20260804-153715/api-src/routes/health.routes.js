const express = require("express");

const router = express.Router();

const db = require("../database/prisma");


router.get("/", (req, res) => {

    res.json({

        status: "ok",

        service: "XaaSGrid API",

        timestamp: new Date()

    });

});


router.get("/database", async (req, res) => {

    try {

        const result = await db.query(
            "SELECT NOW()"
        );


        res.json({

            status: "connected",

            database: "postgresql",

            timestamp:
                result.rows[0].now

        });


    } catch (error) {


        res.status(500).json({

            status: "error",

            message: error.message

        });


    }

});


module.exports = router;
