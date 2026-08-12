const express = require("express");
const prisma = require("../database/prisma");

const router = express.Router();

router.get("/status", (req, res) => {
    res.json({
        platform: "XaaSGrid",
        status: "operational",
        version: "1.0.0",
        environment: process.env.NODE_ENV || "development",
        timestamp: new Date().toISOString()
    });
});

router.get("/metrics", async (req, res) => {
    try {
        const [
            users,
            companies,
            customers,
            auditEvents,
            organizations,
            tenants
        ] = await Promise.all([
            prisma.user.count(),
            prisma.company.count(),
            prisma.customer.count(),
            prisma.auditLog.count(),
            prisma.organization.count(),
            prisma.tenant.count()
        ]);

        res.json({
            success: true,
            platform: "XaaSGrid",
            metrics: {
                users,
                companies,
                customers,
                auditEvents,
                organizations,
                tenants
            },
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        console.error("Platform metrics error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load platform metrics",
            error: error.message
        });
    }
});

module.exports = router;
