const requiredEnv = [
  "DATABASE_URL",
  "JWT_SECRET"
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
