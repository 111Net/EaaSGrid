const jwt = require("jsonwebtoken");


function createToken(user){

    return jwt.sign(

    {

        id:user.id,

        email:user.email,

        role:user.role,

        permissions:user.permissions || []

    },

    process.env.JWT_SECRET,

    {

        expiresIn:"8h"

    }

    );

}


module.exports = {
    createToken
};
