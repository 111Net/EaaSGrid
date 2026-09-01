const prisma = require("../../database/prisma");

async function getActivity() {
    const events = await prisma.activityEvent.findMany({
        orderBy: { id: "desc" }
    });

    return events.map(event => ({
        company: event.company,
        event: event.event,
        status: event.status,
        time: event.createdAt
    }));
}

module.exports = {
    getActivity
};
