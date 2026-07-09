const investorService = require("../services/investor.service");


exports.getInvestorProfile = async (req,res,next)=>{

    try {

        const data = await investorService.getInvestor();


        res.json({

            company:data.company_name,

            project:data.project,

            stage:data.stage,

            funding_required:{
                currency:data.funding_currency,
                amount:data.funding_amount
            },

            business_model:data.business_model,

            target_markets:data.target_markets,

            projected_rollout:{
                pilot_sites:data.pilot_sites,
                annual_expansion_sites:data.annual_expansion_sites
            },

            headquarters:data.headquarters

        });


    } catch(error){

        next(error);

    }

};
