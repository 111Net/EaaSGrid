const prisma = require("../../database/prisma");

async function getLifecycle() {
    return prisma.lifecycleInstance.findMany({
        orderBy: { id: "asc" }
    });
}

module.exports = {
    getLifecycle
};
