const pool = require("../config/postgres");

async function getDashboardData() {
  const [
    investorResult,
    sitesResult,
    energyResult,
    performanceResult,
    financeResult
  ] = await Promise.all([
    pool.query(`
      SELECT *
      FROM investors
      LIMIT 1
    `),

    pool.query(`
      SELECT *
      FROM pilot_sites
      ORDER BY created_at
    `),

    pool.query(`
      SELECT *
      FROM energy_metrics
      ORDER BY recorded_at DESC
      LIMIT 1
    `),

    pool.query(`
      SELECT *
      FROM performance_metrics
      ORDER BY recorded_at DESC
      LIMIT 1
    `),

    pool.query(`
      SELECT *
      FROM financial_metrics
      ORDER BY recorded_at DESC
      LIMIT 1
    `)
  ]);

  return {
    investor: investorResult.rows[0] || null,
    sites: sitesResult.rows,
    energy: energyResult.rows[0] || null,
    performance: performanceResult.rows[0] || null,
    finance: financeResult.rows[0] || null
  };
}

module.exports = {
  getDashboardData
};
