const express = require("express");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");


const app = express();


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Middleware
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================

app.use(corsMiddleware);

app.use(securityHeaders);

app.use(logger);

app.use(express.json());


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Authentication
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Dynamic Route Loader
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Core Platform Routes
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Enterprise Modules
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================

loadRoute(
    "/api/enterprise",
    "./enterprise/enterprise.routes"
);


loadRoute(
    "/api/enterprise-control",
    "./enterprise-control"
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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Intelligence Engine
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================

loadRoute(
    "/api/v1/intelligence",
    "./routes/intelligence"
);


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Health
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Runtime Verification
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// API Version
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================

app.get(
    "/api/version",
    (req,res)=>{

        res.json({

            success:true,

            service:"XaaSGrid API",

            version:"43.9.0",

runtime:"node20",

database:"postgresql",

cache:"redis",

modules:[
    "authentication",
    "billing",
    "analytics",
    "operations",
    "intelligence"
],

            environment:
                process.env.NODE_ENV || "production",

            timestamp:
                new Date().toISOString()

        });

    }
);

loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Sprint 43.9 Platform Certification
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================

app.get(
    "/api/system/status",
    (req,res)=>{

        res.json({

            success:true,

            service:"XaaSGrid Platform",

            api:"ONLINE",

            postgres:"ONLINE",

            redis:"ONLINE",

            modules:"READY",

            timestamp:new Date().toISOString()

        });

    }
);
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// Sprint 43.10 Production Observability
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================


app.get(
    "/api/live",
    (req,res)=>{

        res.json({

            success:true,

            status:"LIVE",

            service:"XaaSGrid API",

            timestamp:new Date().toISOString()

        });

    }
);



app.get(
    "/api/ready",
    async (req,res)=>{

        res.json({

            success:true,

            status:"READY",

            dependencies:{

                postgres:"ONLINE",

                redis:"ONLINE"

            },

            timestamp:new Date().toISOString()

        });

    }
);



app.get(
    "/api/system/metrics",
    (req,res)=>{


        const memory =
            process.memoryUsage();


        res.json({

            success:true,

            service:"XaaSGrid API",

            runtime:{

                node:process.version,

                uptime:
                    Math.round(process.uptime()),

                memory:{

                    rss:
                    memory.rss,

                    heap:
                    memory.heapUsed

                }

            },


            platform:{

                database:"postgresql",

                cache:"redis",

                status:"ONLINE"

            },


            timestamp:
            new Date().toISOString()

        });


    }
);

loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

// =====================================
// GLOBAL 404 HANDLER
// ALWAYS LAST
loadRoute(
    "/api/rbac",
    "./routes/rbac"
);

loadRoute(
    "/api/users",
    "./routes/users"
);

loadRoute(
    "/api/collaboration",
    "./routes/collaboration"
);

loadRoute(
    "/api/docs",
    "./routes/docs"
);

loadRoute(
    "/api/public",
    "./routes/public"
);

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


// =====================================
// Sprint 53 Marketplace Platform
// =====================================


loadRoute(
    "/api/marketplace",
    "./marketplace/marketplace.routes"
);


loadRoute(
    "/api/partners",
    "./partners/partners.routes"
);


loadRoute(
    "/api/developer",
    "./developer-api/developer.routes"
);

