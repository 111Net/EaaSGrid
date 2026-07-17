const pool = require("../config/postgres");

async function getDashboardData() {
  const [
    providerResult,
    devicesResult,
    energyResult,
    ledgerResult
  ] = await Promise.all([
    pool.query(`
      SELECT
        provider_code,
        company_name,
        email,
        phone,
        service_type
      FROM providers
      ORDER BY id ASC
      LIMIT 1
    `),

    pool.query(`
      SELECT
        id,
        device_code,
        device_type,
        manufacturer,
        connectivity
      FROM devices
      ORDER BY id ASC
    `),

    pool.query(`
      SELECT
        COALESCE(SUM(kwh), 0) AS total_kwh,
        COALESCE(SUM(cost), 0) AS total_cost,
        COUNT(*)::int AS reading_count
      FROM energy_usage
    `),

    pool.query(`
      SELECT
        COALESCE(SUM(balance_cached), 0) AS portfolio_value
      FROM ledger_accounts
    `)
  ]);

  const provider = providerResult.rows[0] || null;
  const devices = devicesResult.rows;
  const energy = energyResult.rows[0] || {};
  const ledger = ledgerResult.rows[0] || {};

  return {
    investor: {
      company_name: provider?.company_name || "EaaSGrid",
      project: "Energy-as-a-Service Platform",
      stage: "Pilot Deployment",
      funding_currency: "NGN",
      funding_amount: 298000000,
      business_model: "Energy-as-a-Service",
      target_markets: [
        "Nigeria",
        "Commercial and institutional energy users"
      ],
      pilot_sites: 6,
      annual_expansion_sites: 60,
      headquarters: "Ibadan, Oyo State, Nigeria"
    },

    sites: devices.map(device => ({
      id: device.id,
      site_code: device.device_code,
      site_name: device.device_code || `Device ${device.id}`,
      status: "Active",
      device_type: device.device_type,
      manufacturer: device.manufacturer,
      connectivity: device.connectivity
    })),

    energy: {
      monthly_generation_mwh:
        Number(energy.total_kwh || 0) / 1000,

      battery_utilisation_percent: 0,

      connected_assets: devices.length
    },

    performance: {
      availability_percent:
        devices.length > 0 ? 100 : 0,

      maintenance_alerts: 0
    },

    finance: {
      monthly_revenue_ngn: Number(energy.total_cost || 0),

      portfolio_value_ngn:
        Number(ledger.portfolio_value || 0)
    }
  };
}

module.exports = {
  getDashboardData
};
