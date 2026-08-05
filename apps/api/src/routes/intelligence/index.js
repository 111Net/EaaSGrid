const express=require("express");

const router=express.Router();

const metrics=require("../../intelligence/metrics/metrics.service");
const activity=require("../../intelligence/activity/activity.service");
const lifecycle=require("../../intelligence/lifecycle/lifecycle.service");
const health=require("../../intelligence/health/service-health");


router.get("/metrics",(req,res)=>{
res.json({
success:true,
data:metrics.getMetrics()
});
});


router.get("/activity",(req,res)=>{
res.json({
success:true,
data:activity.getActivity()
});
});


router.get("/lifecycle",(req,res)=>{
res.json({
success:true,
data:lifecycle.getLifecycle()
});
});


router.get("/services",(req,res)=>{
res.json({
success:true,
data:health.getHealth()
});
});


module.exports=router;
