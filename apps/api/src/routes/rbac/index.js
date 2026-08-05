

const express=require("express");

const router=express.Router();

const {
authenticate,
requireRole
}=require("../../auth/auth.middleware");



router.get(

"/admin",

authenticate,

requireRole(
"SUPER_ADMIN",
"ADMIN"
),

(req,res)=>{


res.json({

success:true,

message:"RBAC access granted",

user:req.user

});


}

);



module.exports=router;

