const path = require("path");

require("dotenv").config({
  path: path.resolve(__dirname, "../../../.env")
});

require("./config/env");

const app = require("./app");
const config = require("./config/config");


const server = app.listen(config.port, "0.0.0.0", () => {

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


// Sprint 1 Commercial Routes

app.use(
"/api/v1/customer",
require("./customer/customer.routes")
);


app.use(
"/api/v1/subscription",
require("./subscription/subscription.routes")
);


app.use(
"/api/v1/billing",
require("./billing/billing.routes")
);


app.use(
"/api/v1/partner",
require("./partner/partner.routes")
);


app.use(
"/api/v1/investor",
require("./investor/investor.routes")
);


app.use(
"/api/v1/monitoring",
require("./monitoring/monitoring.routes")
);

