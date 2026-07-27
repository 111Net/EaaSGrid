const router = require("express").Router();

const authenticate = require("../middleware/auth");


router.get(
"/profile",
authenticate,
(req,res)=>{

    res.json({

        message:"Protected route access granted",

        user:req.user

    });

});


module.exports = router;
