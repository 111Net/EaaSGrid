

const prisma =
require("../src/database/prisma");


async function main(){


const exists =
await prisma.service.findFirst();


if(!exists){


await prisma.service.create({

data:{


name:
"Everything-as-a-Service Platform",

description:
"XaaSGrid Commercial Service Marketplace",

category:
"Platform"


}

});


console.log(
"Marketplace service created"
);


}


}


main()

.then(()=>process.exit())

.catch(e=>{

console.error(e);

process.exit(1);

});


