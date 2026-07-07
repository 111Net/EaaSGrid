const supabase = require("../config/database");

async function testDatabaseConnection() {

  if (!supabase) {
    return {
      status: "not_configured",
      message: "Supabase credentials missing"
    };
  }

  const { data, error } = await supabase
    .from("health_check")
    .select("*")
    .limit(1);

  if (error) {
    return {
      status: "error",
      message: error.message
    };
  }

  return {
    status: "connected",
    data
  };
}

module.exports = {
  testDatabaseConnection
};
