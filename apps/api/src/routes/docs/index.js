

const express=require("express");

const router=express.Router();

const service=require("../../knowledge/knowledge.service");



router.get("/",(req,res)=>{

res.json({

success:true,

categories:[

"platform",
"partners",
"investors",
"customers"

]

});

});



router.get("/:type",(req,res)=>{


res.json({

success:true,

data:
service.get(req.params.type)

});


});



module.exports=router;


