
const prisma = require("../src/database/prisma");

async function main(){

    console.log("Starting Sprint 22 seed");

    const admin =
    await prisma.user.create({
        data:{
            email:"admin@xaasgrid.com",
            name:"XaaSGrid Administrator"
        }
    }).catch(e=>null);


    const company =
    await prisma.company.create({
        data:{
            name:"XaaSGrid Demo Company"
        }
    }).catch(e=>null);


    const customer =
    await prisma.customer.create({
        data:{
            name:"Demo Customer"
        }
    }).catch(e=>null);


    const audit =
    await prisma.auditLog.create({
        data:{
            action:"SPRINT22_DATABASE_ACTIVATION"
        }
    }).catch(e=>null);


    console.log({
        admin,
        company,
        customer,
        audit
    });

}


main()
.then(async()=>{
    await prisma.$disconnect();
})
.catch(async(error)=>{
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
});

