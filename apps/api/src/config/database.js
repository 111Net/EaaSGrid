const path = require("path");
const { createClient } = require("@supabase/supabase-js");
const WebSocket = require("ws");
const dotenv = require("dotenv");


// Load project root environment file
dotenv.config({
  path: path.resolve(
    __dirname,
    "../../../../.env"
  )
});


const SUPABASE_URL =
  process.env.SUPABASE_URL;


const SUPABASE_SERVICE_ROLE_KEY =
  process.env.SUPABASE_SERVICE_ROLE_KEY;



if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {

  console.error(
    "Supabase configuration missing."
  );

  console.error(
    "Expected SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY"
  );

  module.exports = null;

} else {


  module.exports =
    createClient(
      SUPABASE_URL,
      SUPABASE_SERVICE_ROLE_KEY,
      {
        realtime: {
          transport: WebSocket
        }
      }
    );

}
