const express = require("express");

const router = express.Router();

const healthRoutes = require("./health.routes");
const companyRoutes = require("./company.routes");
const investorRoutes = require("./investor.routes");

router.use("/health", healthRoutes);
router.use("/company", companyRoutes);
router.use("/investor", investorRoutes);

module.exports = router;
