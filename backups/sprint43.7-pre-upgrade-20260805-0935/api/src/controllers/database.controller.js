const prisma = require("../database/prisma")

exports.testDatabase = async (req, res) => {
    try {
        const { data, error } = await prisma
            .from("companies")
            .select("*");

        if (error) {
            return res.status(500).json({
                success: false,
                error: error.message
            });
        }

        res.json({
            success: true,
            rows: data.length,
            data
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            error: err.message
        });
    }
};
