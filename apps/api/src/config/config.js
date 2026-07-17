module.exports = {
  port: process.env.PORT || 4000,

  environment: process.env.NODE_ENV || "development",

  database: {
    url: process.env.DATABASE_URL
  }
};
