
const prisma=require("../database/prisma");


async function getCompanies(){

return prisma.company.findMany();

}


module.exports={
getCompanies
};

