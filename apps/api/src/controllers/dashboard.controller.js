const dashboardService =
require("../services/dashboard.service");


exports.getDashboard = async(req,res,next)=>{

try{

const data =
await dashboardService.getDashboardData();


res.json({

success:true,

data:data

});


}catch(error){

next(error);

}

};
