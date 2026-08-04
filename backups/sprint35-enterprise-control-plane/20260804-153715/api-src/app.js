const express = require("express");

const app = express();


const routes = require("./routes");

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



app.get("/", (req,res)=>{

    res.json({

        service:"XaaSGrid API",

        status:"running",

        version:"1.0.0"

    });

});



app.get("/api/health",(req,res)=>{

    res.json({

        status:"ok",

        service:"XaaSGrid API",

        timestamp:new Date().toISOString()

    });

});



// Authentication

app.use(
"/api/auth",
require("./auth/auth.routes")
);



// Core API routes

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



// 404 handler MUST ALWAYS BE LAST

app.use((req,res)=>{

    res.status(404).json({

        success:false,

        message:"Route not found"

    });

});



module.exports = app;
