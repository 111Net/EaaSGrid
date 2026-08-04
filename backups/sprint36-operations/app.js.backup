const express = require("express");

const app = express();


// Core routes

const routes = require("./routes");


// Middleware

const corsMiddleware =
    require("./middleware/cors");

const securityHeaders =
    require("./middleware/security");

const logger =
    require("./middleware/logger");


// Middleware stack

app.use(corsMiddleware);

app.use(securityHeaders);

app.use(logger);

app.use(express.json());


// Root endpoint

app.get("/", (req, res) => {

    res.json({

        service: "XaaSGrid API",

        status: "running",

        version: "1.0.0"

    });

});


// Health endpoint

app.get("/api/health", (req, res) => {

    res.json({

        status: "ok",

        service: "XaaSGrid API",

        timestamp: new Date().toISOString()

    });

});


// Authentication routes

app.use(
    "/api/auth",
    require("./auth/auth.routes")
);


// Existing API routes

app.use(
    "/api",
    routes
);



// Sprint 34 Enterprise Administration

const enterpriseRoutes =
    require("./enterprise/enterprise.routes");


app.use(
    "/api/enterprise",
    enterpriseRoutes
);



// Sprint 35 Enterprise Control Plane

const enterpriseControlRoutes =
    require("./enterprise-control");


app.use(
    "/api/enterprise-control",
    enterpriseControlRoutes
);



// 404 handler MUST ALWAYS BE LAST

app.use((req, res) => {

    res.status(404).json({

        success: false,

        message: "Route not found"

    });

});



module.exports = app;
