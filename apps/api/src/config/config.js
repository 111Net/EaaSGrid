module.exports = {
  port: process.env.PORT || 4000,

  environment: process.env.NODE_ENV || "development",

  supabase: {
    url: process.env.SUPABASE_URL,
    key: process.env.SUPABASE_SERVICE_ROLE_KEY
  }
};
