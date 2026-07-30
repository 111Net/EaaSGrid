
const service=require("./auth.service");


exports.login=async(req,res)=>{


try{


const result =
await service.login(
req.body.email,
req.body.password
);


res.json(result);


}

catch(error){

res.status(401).json({

message:error.message

});

}


};

