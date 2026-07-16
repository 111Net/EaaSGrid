require("dotenv").config();

const fs = require("fs");
const path = require("path");
const pool = require("./apps/api/src/config/postgres");

const rootDirs = [
  "apps/api/src/services",
  "apps/api/src/routes",
  "apps/api/src/controllers"
];

const sqlTablePattern =
  /\b(?:FROM|JOIN|UPDATE|INTO|DELETE\s+FROM)\s+["`]?([a-zA-Z_][a-zA-Z0-9_]*)["`]?/gi;

function scanFiles(dir) {
  const results = [];

  if (!fs.existsSync(dir)) return results;

  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      results.push(...scanFiles(fullPath));
    } else if (/\.(js|ts|tsx)$/.test(entry.name)) {
      const content = fs.readFileSync(fullPath, "utf8");
      let match;

      while ((match = sqlTablePattern.exec(content)) !== null) {
        results.push({
          file: fullPath,
          table: match[1]
        });
      }
    }
  }

  return results;
}

(async () => {
  try {
    const dbResult = await pool.query(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
    `);

    const dbTables = new Set(
      dbResult.rows.map(row => row.table_name)
    );

    const references = rootDirs.flatMap(scanFiles);

    const uniqueReferences = [
      ...new Map(
        references.map(item => [
          `${item.file}:${item.table}`,
          item
        ])
      ).values()
    ];

    const missing = uniqueReferences.filter(
      item => !dbTables.has(item.table)
    );

    const existing = uniqueReferences.filter(
      item => dbTables.has(item.table)
    );

    console.log("\n=== EAASGRID PHASE 5 SCHEMA AUDIT ===\n");

    console.log(`DATABASE_TABLES=${dbTables.size}`);
    console.log(`CODE_TABLE_REFERENCES=${uniqueReferences.length}`);
    console.log(`EXISTING_REFERENCES=${existing.length}`);
    console.log(`MISSING_REFERENCES=${missing.length}`);

    console.log("\n--- DATABASE TABLES ---");
    console.table([...dbTables].sort().map(table => ({ table })));

    console.log("\n--- MISSING APPLICATION TABLE REFERENCES ---");
    console.table(missing);

    if (missing.length > 0) {
      console.log("\nPHASE5_SCHEMA_AUDIT_STATUS=FAIL");
      process.exitCode = 1;
    } else {
      console.log("\nPHASE5_SCHEMA_AUDIT_STATUS=PASS");
    }
  } catch (error) {
    console.error("\nPHASE5_SCHEMA_AUDIT_STATUS=ERROR");
    console.error(error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
})();
