const express = require("express");
const router = express.Router();

const databaseController = require("../controllers/database.controller");

router.get("/", databaseController.testDatabase);

module.exports = router;
