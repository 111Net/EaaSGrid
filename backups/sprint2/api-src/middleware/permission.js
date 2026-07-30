function requirePermission(permission){

    return function(req,res,next){

        try {

            const permissions =
                req.user?.permissions || [];


            if(!permissions.includes(permission)){

                return res.status(403).json({

                    success:false,

                    message:"Permission denied",

                    required:permission

                });

            }


            next();


        } catch(error){

            return res.status(500).json({

                success:false,

                message:"Permission validation failed"

            });

        }

    };

}


module.exports = requirePermission;
