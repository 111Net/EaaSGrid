const dashboardService = require("../services/dashboard.service");

exports.getDashboard = async (req, res, next) => {
  try {
    const dashboard = await dashboardService.getDashboardData();

    const investor = dashboard.investor || {};
    const energy = dashboard.energy || {};
    const performance = dashboard.performance || {};
    const finance = dashboard.finance || {};
    const sites = dashboard.sites || [];

    res.json({
      success: true,

      message: "Dashboard data retrieved successfully",

      data: {
        platform: {
          name: "EaaSGrid",
          version: "1.0.0",
          environment: process.env.NODE_ENV || "development",
          server_time: new Date().toISOString()
        },

        company: {
          name: investor.company_name || "EaaSGrid",
          headquarters:
            investor.headquarters || "Ibadan, Oyo State, Nigeria",
          project:
            investor.project || "Energy-as-a-Service Platform"
        },

        dashboard: {
          status: "Operational",
          last_updated: new Date().toISOString()
        },

        infrastructure: {
          pilot_sites: investor.pilot_sites || 0,
          planned_sites_per_year:
            investor.annual_expansion_sites || 0,
          active_sites:
            sites.filter(site => site.status === "Active").length,
          monitored_sites:
            energy.connected_assets || 0
        },

        investment: {
          required_capital_ngn:
            investor.funding_amount || 0,
          currency:
            investor.funding_currency || "NGN",
          funding_stage:
            investor.stage || "Pilot Deployment"
        },

        energy: {
          monthly_generation:
            energy.monthly_generation_mwh || 0,
          battery_utilisation:
            energy.battery_utilisation_percent || 0,
          connected_assets:
            energy.connected_assets || 0
        },

        finance: {
          monthly_revenue:
            finance.monthly_revenue_ngn || 0,
          portfolio_value:
            finance.portfolio_value_ngn || 0
        },

        performance: {
          availability:
            performance.availability_percent || 0,
          maintenance_alerts:
            performance.maintenance_alerts || 0
        },

        sites,

        business_model:
          investor.business_model || "Energy-as-a-Service",

        target_markets:
          investor.target_markets || []
      }
    });
  } catch (error) {
    next(error);
  }
};
