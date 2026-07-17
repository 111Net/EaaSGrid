const express = require("express");
const router = express.Router();

const pool = require("../config/postgres");

router.get("/", (req, res) => {
  res.json({
    status: "ok",
    service: "eaasgrid-api"
  });
});

router.get("/database", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT current_database() AS database,
             current_user AS user,
             current_timestamp AS server_time
    `);

    res.json({
      status: "connected",
      database: result.rows[0]
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message
    });
  }
});

module.exports = router;
