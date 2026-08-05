

const router=require("express").Router();


router.get("/profile",(req,res)=>{


res.json({

success:true,

portal:"XaaSGrid Customer Portal",

features:[

"Services",

"Subscriptions",

"Invoices",

"Payments"

]

});


});


module.exports=router;

