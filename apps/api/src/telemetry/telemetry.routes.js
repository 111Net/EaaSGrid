
const express=require("express");

const router=express.Router();


router.post("/ingest",(req,res)=>{

res.json({

success:true,
message:"Telemetry received"

});

});


router.get("/latest",(req,res)=>{

res.json({

energy:"0 kWh",
status:"operational"

});

});


module.exports=router;

