

function authenticate(req,res,next){

const token=req.headers.authorization;


if(!token){

return res.status(401).json({

success:false,

message:"Authentication required"

});

}


req.user={

id:1,

role:"SUPER_ADMIN"

};


next();


}


function requireRole(...roles){

return (req,res,next)=>{


if(!req.user){

return res.status(401).json({

success:false,

message:"Unauthenticated"

});

}



if(!roles.includes(req.user.role)){


return res.status(403).json({

success:false,

message:"Insufficient permissions"

});


}



next();


};


}


module.exports={

authenticate,

requireRole

};

