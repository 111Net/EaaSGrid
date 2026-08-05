const express = require("express");

const app = express();


// =====================================
// Middleware
// =====================================

const corsMiddleware =
    require("./middleware/cors");

const securityHeaders =
    require("./middleware/security");

const logger =
    require("./middleware/logger");


app.use(corsMiddleware);

app.use(securityHeaders);

app.use(logger);

app.use(express.json());


// =====================================
// Root
// =====================================

app.get("/", (req, res) => {

    res.json({

        service: "XaaSGrid API",

        status: "running",

        version: "1.0.0"

    });

});


// =====================================
// Health
// =====================================

app.get("/api/health", (req,res)=>{

    res.json({

        status:"ok",

        service:"XaaSGrid API",

        timestamp:new Date().toISOString()

    });

});


// =====================================
// Authentication
// =====================================

app.use(
    "/api/auth",
    require("./auth/auth.routes")
);


// =====================================
// Core API Routes
// =====================================

const routes =
    require("./routes");


app.use(
    "/api",
    routes
);



// =====================================
// Enterprise Modules
// =====================================

function registerOptionalRoute(
    path,
    modulePath
){

    try {


        const route =
            require(modulePath);


        app.use(
            path,
            route
        );


        console.log(
            "Loaded:",
            path
        );


    }
    catch(error){

        console.log(
            "Skipped:",
            path
        );

    }

}



// Enterprise Administration

registerOptionalRoute(
"/api/enterprise",
"./enterprise/enterprise.routes"
);



// Enterprise Control Plane

registerOptionalRoute(
"/api/enterprise-control",
"./enterprise-control/enterprise-control.routes"
);



// Operations Intelligence

registerOptionalRoute(
"/api/operations",
"./operations/operations.routes"
);



// Analytics Engine

registerOptionalRoute(
"/api/analytics",
"./analytics/analytics.routes"
);



// Customer onboarding

registerOptionalRoute(
"/api/onboarding",
"./onboarding/onboarding.routes"
);



// =====================================
// 404 HANDLER
// MUST ALWAYS BE LAST
// =====================================

app.use((req,res)=>{

    res.status(404).json({

        success:false,

        message:"Route not found"

    });

});


// =====================================

module.exports = app;
