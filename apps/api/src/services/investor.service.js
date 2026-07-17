const pool = require("../config/postgres");

async function getInvestor() {
  const providerResult = await pool.query(`
    SELECT
      provider_code,
      company_name,
      email,
      phone,
      service_type
    FROM providers
    ORDER BY id ASC
    LIMIT 1
  `);

  const provider = providerResult.rows[0] || {};

  return {
    company: provider.company_name || "EaaSGrid",
    project: "Energy-as-a-Service Platform",
    stage: "Pilot Deployment",
    funding_required: {
      currency: "NGN",
      amount: 298000000
    },
    business_model: "Energy-as-a-Service",
    target_markets: [
      "Nigeria",
      "Commercial and institutional energy users"
    ],
    projected_rollout: {
      pilot_sites: 6,
      annual_expansion_sites: 60
    },
    headquarters: "Ibadan, Oyo State, Nigeria"
  };
}

module.exports = {
  getInvestor
};
