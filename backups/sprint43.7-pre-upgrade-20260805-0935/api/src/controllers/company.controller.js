const companyService = require("../services/company.service");


exports.getCompany = async (req,res,next)=>{

    try{

        const company = await companyService.getCompany();


        res.json({

            success:true,

            message:"Company retrieved successfully",

            data:company

        });


    }catch(error){

        next(error);

    }

};
