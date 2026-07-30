
const jwt = require("jsonwebtoken");

const secret =
process.env.JWT_SECRET || "change-this-secret";


function generateToken(payload)
{
    return jwt.sign(
        payload,
        secret,
        {
            expiresIn:"8h"
        }
    );
}


function verifyToken(token)
{
    return jwt.verify(
        token,
        secret
    );
}


module.exports =
{
    generateToken,
    verifyToken
};

