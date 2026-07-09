const requiredEnv = [
  "SUPABASE_URL",
  "SUPABASE_SERVICE_ROLE_KEY"
];

requiredEnv.forEach((key) => {

  if (!process.env[key]) {

    console.error(
      `Missing required environment variable: ${key}`
    );

    process.exit(1);

  }

});


module.exports = {
  validated: true
};
