

const express=require("express");

const router=express.Router();


router.get("/team",(req,res)=>{

res.json({

success:true,

data:[

{
name:"Platform Administration",
type:"Internal Team"
}

]

});


});



router.get("/partners",(req,res)=>{


res.json({

success:true,

data:[]

});


});



router.get("/investors",(req,res)=>{


res.json({

success:true,

data:[]

});


});



router.get("/customers",(req,res)=>{


res.json({

success:true,

data:[]

});


});


module.exports=router;


