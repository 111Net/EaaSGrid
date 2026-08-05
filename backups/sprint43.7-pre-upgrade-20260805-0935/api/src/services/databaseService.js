const prisma = require("../database/prisma");

async function testDatabaseConnection() {

  if (!prisma) {
    return {
      status: "not_configured",
      message: "Supabase credentials missing"
    };
  }

  const { data, error } = await prisma
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
