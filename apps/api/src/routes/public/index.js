

const express=require("express");

const router=express.Router();

const fs=require("fs");

const path=require("path");



function load(name){

return JSON.parse(

fs.readFileSync(

path.join(
process.cwd(),
"content/website",
name+".json"
)

)

);

}



router.get("/:page",(req,res)=>{


try{


res.json({

success:true,

data:load(req.params.page)

});


}

catch(e){


res.status(404).json({

success:false,

message:"Content not found"

});


}


});





router.post("/contact",(req,res)=>{


res.json({

success:true,

message:"Contact request received",

data:req.body

});


});



module.exports=router;

