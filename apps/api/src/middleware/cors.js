const cors = require("cors");


const allowedOrigins = (
process.env.CORS_ORIGINS ||
"http://localhost:3000,http://localhost:3001"
)
.split(",");



module.exports = cors({

origin(origin, callback){


if(!origin)
{
return callback(null,true);
}


if(
allowedOrigins.includes(origin)
)
{
return callback(null,true);
}


return callback(
new Error("CORS policy blocked request")
);

},


methods:[
"GET",
"POST",
"PUT",
"PATCH",
"DELETE"
],


allowedHeaders:[
"Content-Type",
"Authorization"
],


credentials:true

});
