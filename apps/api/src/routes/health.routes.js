const express = require("express");
const router = express.Router();

const supabase = require("../config/database");


router.get("/", (req,res)=>{
    res.json({
        status:"ok",
        service:"eaasgrid-api"
    });
});


router.get("/database", async(req,res)=>{

    if(!supabase){
        return res.json({
            status:"failed",
            message:"Supabase not configured"
        });
    }


    const {data,error}=await supabase
        .from("companies")
        .select("*")
        .limit(1);


    if(error){
        return res.json({
            status:"error",
            message:error.message
        });
    }


    res.json({
        status:"connected",
        data
    });

});


module.exports=router;
