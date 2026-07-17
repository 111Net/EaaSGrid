const pool = require("../config/postgres");

exports.testDatabase = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT current_database() AS database,
             current_user AS user,
             current_timestamp AS server_time
    `);

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
};
