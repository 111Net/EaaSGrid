const pool = require("../config/postgres");

async function getInvestor() {
  const result = await pool.query(`
    SELECT *
    FROM investors
    LIMIT 1
  `);

  return result.rows[0] || null;
}

module.exports = {
  getInvestor
};
