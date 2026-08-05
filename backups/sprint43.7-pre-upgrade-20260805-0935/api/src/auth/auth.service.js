
const bcrypt=require("bcrypt");

const users=[];


async function createUser(email,password,role="user")
{

const passwordHash =
await bcrypt.hash(password,10);


return {
email,
passwordHash,
role
};

}


async function verifyPassword(password,hash)
{

return bcrypt.compare(password,hash);

}


module.exports={
createUser,
verifyPassword
};

