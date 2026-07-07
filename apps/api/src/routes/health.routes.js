const express = require("express");
const router = express.Router();

const {
 testDatabaseConnection
} = require("../services/databaseService");


router.get("/database", async (req,res)=>{

 const result = await testDatabaseConnection();

 res.json(result);

});


module.exports = router;
