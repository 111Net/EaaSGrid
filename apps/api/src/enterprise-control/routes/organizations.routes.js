const express = require("express");
const prisma = require("../../database/prisma");

const router = express.Router();

router.get("/", async (req, res) => {
    try {
        const organizations = await prisma.organization.findMany({
            orderBy: {
                createdAt: "desc"
            }
        });

        res.json({
            success: true,
            organizations: organizations.map((organization) => ({
                id: organization.id,
                name: organization.name,
                status: "ACTIVE",
                createdAt: organization.createdAt
            }))
        });
    } catch (error) {
        console.error("Organizations GET error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load organizations"
        });
    }
});

router.post("/", async (req, res) => {
    try {
        const name =
            typeof req.body?.name === "string"
                ? req.body.name.trim()
                : "";

        if (!name) {
            return res.status(400).json({
                success: false,
                message: "Organization name is required"
            });
        }

        const organization = await prisma.organization.create({
            data: {
                name
            }
        });

        res.status(201).json({
            success: true,
            organization: {
                id: organization.id,
                name: organization.name,
                status: "ACTIVE",
                createdAt: organization.createdAt
            }
        });
    } catch (error) {
        console.error("Organizations POST error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to create organization"
        });
    }
});

module.exports = router;
