require("dotenv").config();

const pool = require("./apps/api/src/config/postgres");

(async () => {
  try {
    const result = await pool.query(`
      SELECT
        table_name,
        column_name,
        data_type,
        is_nullable,
        column_default
      FROM information_schema.columns
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position
    `);

    const grouped = {};

    for (const row of result.rows) {
      if (!grouped[row.table_name]) {
        grouped[row.table_name] = [];
      }

      grouped[row.table_name].push({
        column: row.column_name,
        type: row.data_type,
        nullable: row.is_nullable,
        default: row.column_default
      });
    }

    console.log("\n=== EAASGRID PHASE 5 DATABASE SCHEMA INSPECTION ===\n");

    for (const [table, columns] of Object.entries(grouped)) {
      console.log(`\n--- ${table} ---`);
      console.table(columns);
    }

    console.log("\nPHASE5_DATABASE_INSPECTION_STATUS=PASS");
  } catch (error) {
    console.error("\nPHASE5_DATABASE_INSPECTION_STATUS=FAIL");
    console.error(error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
})();
