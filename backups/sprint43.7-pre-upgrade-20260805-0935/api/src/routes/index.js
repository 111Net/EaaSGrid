const express = require("express");

const router = express.Router();

router.use(
    "/dashboard",
    require("./dashboard.routes")
);

router.use(
    "/investor",
    require("./investor.routes")
);

router.use(
    "/database",
    require("./database.routes")
);

router.use(
    "/company",
    require("./company.routes")
);

router.use(
    "/billing",
    require("./billing")
);

router.use(
    "/platform",
    require("./platform.metrics")
);

module.exports = router;
