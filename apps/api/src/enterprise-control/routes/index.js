

const express = require("express");

const router = express.Router();



router.use(
"/organizations",
require("./organizations.routes")
);



router.use(
"/tenants",
require("./tenants.routes")
);



router.use(
"/rbac",
require("./rbac.routes")
);



router.use(
"/governance",
require("./governance.routes")
);



module.exports = router;

