const prisma = require("../../database/prisma");

async function getMetrics() {
    const [
        customers,
        services,
        apiRequests,
        uptime,
        revenue
    ] = await Promise.all([
        prisma.customerAccount.count(),

        prisma.platformMetric.findFirst({
            where: { metricName: "services" },
            orderBy: { id: "desc" }
        }),

        prisma.platformMetric.findFirst({
            where: { metricName: "apiRequests" },
            orderBy: { id: "desc" }
        }),

        prisma.platformMetric.findFirst({
            where: { metricName: "uptime" },
            orderBy: { id: "desc" }
        }),

        prisma.platformMetric.findFirst({
            where: { metricName: "revenue" },
            orderBy: { id: "desc" }
        })
    ]);

    return {
        revenue: revenue?.metricValue != null
            ? Number(revenue.metricValue)
            : 0,

        customers,

        services: services?.metricValue != null
            ? Number(services.metricValue)
            : 0,

        apiRequests: apiRequests?.metricValue != null
            ? Number(apiRequests.metricValue)
            : 0,

        uptime: uptime?.metricValue != null
            ? Number(uptime.metricValue)
            : 0
    };
}

module.exports = {
    getMetrics
};
