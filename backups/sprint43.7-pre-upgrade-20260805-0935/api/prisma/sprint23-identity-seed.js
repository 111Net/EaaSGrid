
const prisma = require("../src/database/prisma");
const bcrypt = require("bcrypt");

async function main(){

const existing =
await prisma.user.findUnique({
where:{
email:"admin@xaasgrid.com"
}
});


if(!existing){

const passwordHash =
await bcrypt.hash(
"XaaSGridAdmin2026!",
10
);


await prisma.user.create({

data:{

email:"admin@xaasgrid.com",

passwordHash: passwordHash,

role:"ADMIN"

}

});

console.log("Production admin created");

}

else{

console.log("Production admin already exists");

}


const count =
await prisma.user.count();


console.log(
"Users:",
count
);


}


main()
.catch(err=>{

console.error(err);

process.exit(1);

})
.finally(async()=>{

await prisma.$disconnect();

});

