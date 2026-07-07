const express = require("express");

const router = express.Router();

const {
  getCompanyProfile
} = require("../controllers/company.controller");


router.get("/", getCompanyProfile);


module.exports = router;
