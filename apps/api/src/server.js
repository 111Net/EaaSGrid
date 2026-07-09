const path = require("path");

require("dotenv").config({
  path: path.resolve(__dirname, "../../../.env")
});

require("./config/env");

const app = require("./app");
const config = require("./config/config");


const server = app.listen(config.port, () => {

    console.log(
      `EAASGrid API running on port ${config.port}`
    );

    console.log(
      `Environment: ${config.environment}`
    );

});


const shutdown = (signal) => {

    console.log(`${signal} received. Shutting down gracefully...`);


    server.close(() => {

        console.log(
          "HTTP server closed"
        );


        process.exit(0);

    });


    setTimeout(() => {

        console.error(
          "Forced shutdown after timeout"
        );

        process.exit(1);

    }, 10000);

};


process.on(
    "SIGTERM",
    () => shutdown("SIGTERM")
);


process.on(
    "SIGINT",
    () => shutdown("SIGINT")
);
