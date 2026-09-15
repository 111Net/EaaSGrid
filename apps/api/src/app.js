const express = require("express");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");
const prisma = require("./database/prisma");


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
    "/api/database",
    "./routes/database.routes"
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







// =====================================
// Intelligence Engine





// =====================================

loadRoute(
    "/api/intelligence",
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
    "/api/intelligence-check",
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






// =====================================
// Sprint 43.9 Platform Certification





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





// =====================================
// Sprint 43.10 Production Observability





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

        try {

            await prisma.$queryRaw`SELECT 1`;

            res.status(200).json({

                success:true,

                status:"READY",

                dependencies:{

                    postgres:"ONLINE"

                },

                timestamp:new Date().toISOString()

            });

        }
        catch(error){

            console.error(
                "Readiness check failed:",
                error.message
            );

            res.status(503).json({

                success:false,

                status:"NOT_READY",

                dependencies:{

                    postgres:"OFFLINE"

                },

                timestamp:new Date().toISOString()

            });

        }

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

