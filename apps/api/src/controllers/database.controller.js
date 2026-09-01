const prisma = require("../database/prisma");

exports.testDatabase = async (req, res) => {
    try {
        const result = await prisma.$queryRaw`SELECT NOW() AS now`;

        res.json({
            success: true,
            status: "connected",
            database: "postgresql",
            timestamp: result[0].now
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            status: "error",
            database: "postgresql",
            error: error.message
        });
    }
};
