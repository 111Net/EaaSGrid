

const express=require("express");

const router=express.Router();


const service=require("../../users/user.service");



router.get("/",(req,res)=>{


res.json({

success:true,

data:service.list()

});


});




router.post("/",(req,res)=>{


res.json({

success:true,

data:service.create(req.body)

});


});




router.get("/:id",(req,res)=>{


res.json({

success:true,

data:service.find(req.params.id)

});


});




router.put("/:id",(req,res)=>{


res.json({

success:true,

data:service.update(
req.params.id,
req.body
)

});


});




router.delete("/:id",(req,res)=>{


service.remove(req.params.id);


res.json({

success:true

});


});



module.exports=router;


