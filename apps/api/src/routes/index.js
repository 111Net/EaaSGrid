const express = require("express");

const router = express.Router();

const healthRoutes = require("./health.routes");
const companyRoutes = require("./company.routes");
const investorRoutes = require("./investor.routes");
const dashboardRoutes = require("./dashboard.routes");
const databaseRoutes = require("./database.routes");

router.use("/health", healthRoutes);
router.use("/company", companyRoutes);
router.use("/investor", investorRoutes);
router.use("/dashboard", dashboardRoutes);
router.use("/database", databaseRoutes);

module.exports = router;
