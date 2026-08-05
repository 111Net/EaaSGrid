const express = require("express");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");


const app = express();


// =====================================
// Middleware
// =====================================

app.use(corsMiddleware);

app.use(securityHeaders);

app.use(logger);

app.use(express.json());


// =====================================
// Authentication
// =====================================

try {

    app.use(
        "/api/auth",
        require("./auth/auth.routes")
    );

    console.log("Loaded: /api/auth");

}
catch(error){

    console.log(
        "Skipped: /api/auth"
    );

}


// =====================================
// Dynamic Route Loader
// =====================================

function loadRoute(path,modulePath){

    try {

        app.use(
            path,
            require(modulePath)
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


// =====================================
// Core Platform Routes
// =====================================

loadRoute(
    "/api/dashboard",
    "./routes/dashboard.routes"
);


loadRoute(
    "/api/company",
    "./routes/company.routes"
);


loadRoute(
    "/api/billing",
    "./routes/billing"
);


loadRoute(
    "/api/platform",
    "./routes/platform"
);


// =====================================
// Enterprise Modules
// =====================================

loadRoute(
    "/api/enterprise",
    "./enterprise/enterprise.routes"
);


loadRoute(
    "/api/enterprise-control",
    "./enterprise-control/enterprise-control.routes"
);


loadRoute(
    "/api/operations",
    "./operations/operations.routes"
);


loadRoute(
    "/api/analytics",
    "./analytics/analytics.routes"
);


loadRoute(
    "/api/onboarding",
    "./onboarding/onboarding.routes"
);


// =====================================
// Intelligence Engine
// =====================================

loadRoute(
    "/api/v1/intelligence",
    "./routes/intelligence"
);


// =====================================
// Health
// =====================================

app.get(
    "/api/health",
    (req,res)=>{

        res.json({

            status:"ok",

            service:"xaasgrid-api",

            timestamp:new Date()

        });

    }
);


// =====================================
// Runtime Verification
// =====================================

app.get(
    "/api/v1/intelligence-check",
    (req,res)=>{

        res.json({

            success:true,

            module:"intelligence",

            status:"registered"

        });

    }
);


// =====================================
// API Version
// =====================================

app.get(
    "/api/version",
    (req,res)=>{

        res.json({

            success:true,

            service:"XaaSGrid API",

            version:"43.8.5",

            environment:
                process.env.NODE_ENV || "production",

            timestamp:
                new Date().toISOString()

        });

    }
);


// =====================================
// GLOBAL 404 HANDLER
// ALWAYS LAST
// =====================================

app.use(
    (req,res)=>{

        res.status(404).json({

            success:false,

            message:"Route not found"

        });

    }
);


module.exports = app;
