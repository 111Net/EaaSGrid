const jwt = require("jsonwebtoken");


function authenticate(req,res,next){

    try {

        const header = req.headers.authorization;


        if(!header){

            return res.status(401).json({
                message:"Missing authorization token"
            });

        }


        const token = header.split(" ")[1];


        if(!token){

            return res.status(401).json({
                message:"Invalid token format"
            });

        }


        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET
        );


        req.user = decoded;


        next();


    } catch(error){

        return res.status(401).json({
            message:"Invalid or expired token"
        });

    }

}


module.exports = authenticate;
