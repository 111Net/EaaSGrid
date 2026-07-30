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

        company: {

          name:
            investor.company_name,

          headquarters:
            investor.headquarters,

          project:
            investor.project

        },

        dashboard: {

          status:
            "Operational",

          last_updated:
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

        energy: {

          monthly_generation: null,

          battery_utilisation: null,

          connected_assets: 0

        },

        finance: {

          monthly_revenue: null,

          portfolio_value:
            investor.funding_amount

        },

        performance: {

          availability: null,

          maintenance_alerts: 0

        },

        sites: [],

        business_model:
          investor.business_model,

        target_markets:
          investor.target_markets

      }

    });

  }

  catch (error) {

    next(error);

  }

};
