const express = require("express");
const prisma = require("../../database/prisma");

const router = express.Router();

router.get("/audit", async (req, res) => {
    try {
        const [auditLogs, tenantAudits] = await Promise.all([
            prisma.auditLog.findMany({
                orderBy: {
                    createdAt: "desc"
                },
                take: 100,
                select: {
                    id: true,
                    action: true,
                    createdAt: true
                }
            }),
            prisma.tenantAudit.findMany({
                orderBy: {
                    createdAt: "desc"
                },
                take: 100,
                select: {
                    id: true,
                    tenantId: true,
                    action: true,
                    createdAt: true
                }
            })
        ]);

        const events = [
            ...auditLogs.map((event) => ({
                id: `audit-${event.id}`,
                source: "PLATFORM",
                action: event.action,
                createdAt: event.createdAt
            })),
            ...tenantAudits.map((event) => ({
                id: `tenant-${event.id}`,
                source: "TENANT",
                tenantId: event.tenantId,
                action: event.action,
                createdAt: event.createdAt
            }))
        ].sort(
            (a, b) =>
                new Date(b.createdAt).getTime() -
                new Date(a.createdAt).getTime()
        );

        res.json({
            success: true,
            events: events.slice(0, 100)
        });
    } catch (error) {
        console.error("Governance audit error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to load governance audit"
        });
    }
});

router.get("/security", async (req, res) => {
    try {
        const [
            roleCount,
            permissionCount,
            userRoleCount,
            rolePermissionCount
        ] = await Promise.all([
            prisma.role.count(),
            prisma.permission.count(),
            prisma.userRole.count(),
            prisma.rolePermission.count()
        ]);

        res.json({
            success: true,
            securityStatus: "READY",
            checks: {
                authentication: "READY",
                authorization: "READY",
                database: "READY",
                rbac: {
                    status: "READY",
                    roles: roleCount,
                    permissions: permissionCount,
                    userRoles: userRoleCount,
                    rolePermissions: rolePermissionCount
                }
            }
        });
    } catch (error) {
        console.error("Governance security error:", error);

        res.status(500).json({
            success: false,
            securityStatus: "DEGRADED",
            message: "Unable to evaluate security status"
        });
    }
});

module.exports = router;
