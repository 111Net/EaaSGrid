const express = require("express");

const {
    authenticate,
    requireRole
} = require("../auth/auth.middleware");

const router = express.Router();

/*
 * Enterprise Control Plane
 *
 * Reuses the platform's existing authentication and RBAC
 * middleware. No separate JWT implementation is introduced.
 *
 * Only SUPER_ADMIN and ADMIN may access this control plane.
 */

router.use(
    authenticate,
    requireRole(
        "SUPER_ADMIN",
        "ADMIN"
    )
);

router.get(
    "/overview",
    (req, res) => {
        res.json({
            success: true,
            platform: "XaaSGrid Enterprise Control Plane",
            status: "READY"
        });
    }
);

router.use(
    "/",
    require("./routes")
);

module.exports = router;
