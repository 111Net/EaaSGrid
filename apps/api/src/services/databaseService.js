const pool = require("../config/postgres");

async function testDatabaseConnection() {
  try {
    const result = await pool.query(`
      SELECT current_database() AS database,
             current_user AS user,
             current_timestamp AS server_time
    `);

    return {
      status: "connected",
      data: result.rows[0]
    };
  } catch (error) {
    return {
      status: "error",
      message: error.message
    };
  }
}

module.exports = {
  testDatabaseConnection
};
