const dashboardService = require("../services/dashboard.service");


exports.getDashboard = async (req, res, next) => {

  try {

    const investor =
      await dashboardService.getDashboardData();


    res.json({

      success: true,

      message:
        "Dashboard data retrieved successfully",

      data: {

        platform: {
          name: "EaaSGrid",
          version: "1.0.0",
          environment:
            process.env.NODE_ENV || "development",

          uptime_seconds:
            Math.floor(process.uptime()),

          server_time:
            new Date().toISOString()
        },


        infrastructure: {

          pilot_sites:
            investor.pilot_sites,

          planned_sites_per_year:
            investor.annual_expansion_sites,

          active_sites: 0,

          monitored_sites: 0
        },


        investment: {

          required_capital_ngn:
            investor.funding_amount,

          currency:
            investor.funding_currency,

          funding_stage:
            investor.stage
        },


        business_model:
          investor.business_model,


        target_markets:
          investor.target_markets

      }

    });


  } catch(error) {

    next(error);

  }

};
