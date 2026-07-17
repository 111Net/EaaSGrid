const pool = require("../config/postgres");

async function getCompany() {
  const result = await pool.query(`
    SELECT
      provider_code,
      company_name,
      contact_person,
      email,
      phone,
      service_type
    FROM providers
    ORDER BY id ASC
    LIMIT 1
  `);

  return result.rows[0] || null;
}

module.exports = {
  getCompany
};
