const express = require("express");
const prisma = require("../../database/prisma");

const router = express.Router();

router.get("/", async (req, res) => {
    try {
        const tenants = await prisma.tenant.findMany({
            orderBy: {
                createdAt: "desc"
            }
        });

        res.json({
            success: true,
            tenants: tenants.map((tenant) => ({
                id: tenant.id,
                name: tenant.name,
                organizationId: tenant.organizationId,
                status: "ACTIVE",
                createdAt: tenant.createdAt
            }))
        });
    } catch (error) {
        console.error("Tenants GET error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load tenants"
        });
    }
});

router.post("/", async (req, res) => {
    try {
        const name =
            typeof req.body?.name === "string" &&
            req.body.name.trim()
                ? req.body.name.trim()
                : "New Tenant";

        const organizationId =
            typeof req.body?.organizationId === "string"
                ? req.body.organizationId.trim()
                : "";

        if (!organizationId) {
            return res.status(400).json({
                success: false,
                message: "organizationId is required"
            });
        }

        const organization =
            await prisma.organization.findUnique({
                where: {
                    id: organizationId
                }
            });

        if (!organization) {
            return res.status(400).json({
                success: false,
                message: "Organization not found"
            });
        }

        const tenant = await prisma.tenant.create({
            data: {
                name,
                organizationId
            }
        });

        res.status(201).json({
            success: true,
            tenant: {
                id: tenant.id,
                name: tenant.name,
                organizationId: tenant.organizationId,
                status: "ACTIVE",
                createdAt: tenant.createdAt
            }
        });
    } catch (error) {
        console.error("Tenants POST error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to create tenant"
        });
    }
});

module.exports = router;
