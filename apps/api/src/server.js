const path = require("path");

require("dotenv").config({
  path: path.resolve(__dirname, "../../../.env")
});

console.log("Loaded SUPABASE_URL:", process.env.SUPABASE_URL);

const app = require("./app");
const config = require("./config/config");

app.listen(config.port, () => {
  console.log(`EAASGrid API running on port ${config.port}`);
  console.log(`Environment: ${config.environment}`);
});
