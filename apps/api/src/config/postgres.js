const { Pool } = require("pg");
const path = require("path");
const dotenv = require("dotenv");

dotenv.config({
  path: path.resolve(__dirname, "../../../../.env")
});

const pool = new Pool({
  host: process.env.PGHOST || "/var/run/postgresql",
  port: Number(process.env.PGPORT || 5432),
  database: process.env.PGDATABASE || "eaas_db",
  user: process.env.PGUSER || "eaas_user",

  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

pool.on("error", (err) => {
  console.error("Unexpected PostgreSQL pool error:", err.message);
});

module.exports = pool;
