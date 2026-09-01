const prisma = require("../database/prisma");

async function getCompanies() {
    return prisma.company.findMany();
}

async function getCompany() {
    return prisma.company.findMany();
}

module.exports = {
    getCompany,
    getCompanies
};
