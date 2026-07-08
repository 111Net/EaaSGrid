const supabase = require("../config/database");


exports.getInvestorProfile = async (req,res)=>{


const {data,error}=await supabase
.from("investors")
.select("*")
.single();


if(error){

return res.status(500).json({
error:error.message
});

}


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


};
