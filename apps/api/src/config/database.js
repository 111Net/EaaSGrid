const path = require("path");
const { createClient } = require("@/-js");
const WebSocket = require("ws");
const dotenv = require("dotenv");


// Load project root environment file
dotenv.config({
  path: path.resolve(
    __dirname,
    "../../../../.env"
  )
});


const  =
  process.env.;


const  =
  process.env.;



if (! || !) {

  console.error(
    " configuration missing."
  );

  console.error(
    "Expected  and "
  );

  module.exports = null;

} else {


  module.exports =
    createClient(
      ,
      ,
      {
        realtime: {
          transport: WebSocket
        }
      }
    );

}
