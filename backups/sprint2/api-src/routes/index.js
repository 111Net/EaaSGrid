const express = require("express");

const router = express.Router();

const dashboardRoutes = require("./dashboard.routes");
const healthRoutes = require("./health.routes");
const billingRoutes = require("./billing");
const companyRoutes = require("./company.routes");
const investorRoutes = require("./investor.routes");


router.use("/health", healthRoutes);

router.use("/dashboard", dashboardRoutes);

router.use("/billing", billingRoutes);

router.use("/company", companyRoutes);

router.use("/investor", investorRoutes);


module.exports = router;
