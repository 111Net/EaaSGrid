const pool = require("../config/postgres");

async function getCompany() {
  const result = await pool.query(`
    SELECT *
    FROM companies
    ORDER BY created_at DESC
    LIMIT 1
  `);

  return result.rows[0] || null;
}

module.exports = {
  getCompany
};
