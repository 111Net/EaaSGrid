const supabase = require("../config/database");

exports.getDashboard = async (req, res) => {

  const { data: investor, error } = await supabase
    .from("investors")
    .select("*")
    .single();

  if (error) {
    return res.status(500).json({
      error: error.message
    });
  }

  res.json({

    platform: {
      name: "EaaSGrid",
      version: "1.0.0",
      environment: process.env.NODE_ENV || "development",
      uptime_seconds: Math.floor(process.uptime()),
      server_time: new Date().toISOString()
    },

    api: {
      status: "online",
      version: "v1"
    },

    infrastructure: {
      pilot_sites: investor.pilot_sites,
      planned_sites_per_year: investor.annual_expansion_sites,
      active_sites: 0,
      monitored_sites: 0
    },

    investment: {
      required_capital_ngn: investor.funding_amount,
      funding_status: investor.stage
    },

    system: {
      node_version: process.version,
      platform: process.platform,
      memory: process.memoryUsage()
    }

  });
};
