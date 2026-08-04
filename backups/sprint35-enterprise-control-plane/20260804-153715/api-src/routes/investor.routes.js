const express = require("express");

const router = express.Router();

const {
  getInvestorProfile,
} = require("../controllers/investor.controller");

router.get("/", getInvestorProfile);

module.exports = router;
