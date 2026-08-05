
const express = require("express");
const router = express.Router();

const services = [

{
id:1,
name:"Solar-as-a-Service",
category:"Energy",
status:"active",
provider:"XaaSGrid Energy"
},

{
id:2,
name:"Security-as-a-Service",
category:"Cybersecurity",
status:"active",
provider:"Ironclad Security Advisory"
},

{
id:3,
name:"AI-as-a-Service",
category:"Artificial Intelligence",
status:"active",
provider:"XaaSGrid AI"
},

{
id:4,
name:"Backup-as-a-Service",
category:"Data Protection",
status:"active",
provider:"XaaSGrid Cloud"
}

];


router.get("/services",(req,res)=>{

res.json({

success:true,

count:services.length,

services

});

});


module.exports = router;

