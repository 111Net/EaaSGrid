
const {
 verifyToken
}
=
require("../utils/jwt");


module.exports =
function(req,res,next)
{

const header =
req.headers.authorization;


if(!header)
{
 return res.status(401)
 .json({
 message:"Missing token"
 });
}


const token =
header.replace(
"Bearer ",
""
);


try
{
 req.user =
 verifyToken(token);

 next();

}
catch(error)
{
 return res.status(401)
 .json({
 message:"Invalid token"
 });
}

};

