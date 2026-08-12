const express = require("express");
const prisma = require("../../database/prisma");

const router = express.Router();

router.get("/roles", async (req, res) => {
    try {
        const roles = await prisma.role.findMany({
            orderBy: {
                name: "asc"
            },
            select: {
                id: true,
                name: true,
                description: true
            }
        });

        res.json({
            success: true,
            roles
        });
    } catch (error) {
        console.error("RBAC roles GET error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load roles"
        });
    }
});

router.get("/permissions", async (req, res) => {
    try {
        const permissions = await prisma.permission.findMany({
            orderBy: {
                name: "asc"
            },
            select: {
                id: true,
                name: true,
                description: true
            }
        });

        res.json({
            success: true,
            permissions
        });
    } catch (error) {
        console.error("RBAC permissions GET error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load permissions"
        });
    }
});

module.exports = router;
