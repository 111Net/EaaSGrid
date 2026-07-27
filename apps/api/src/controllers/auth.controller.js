
const auth =
require("../services/auth.service");


async function login(req,res)
{

try
{

const result =
await auth.login(
req.body.email,
req.body.password
);


res.json(result);

}
catch(error)
{

res.status(401)
.json(
{
message:error.message
}
);

}

}


module.exports={
login
};

