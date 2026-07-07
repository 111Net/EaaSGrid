exports.getDashboard = (req, res) => {
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
      pilot_sites: 6,
      planned_sites_per_year: 60,
      active_sites: 0,
      monitored_sites: 0
    },

    investment: {
      required_capital_ngn: 298000000,
      funding_status: "Seeking Investment"
    },

    system: {
      node_version: process.version,
      platform: process.platform,
      memory: process.memoryUsage()
    }
  });
};
