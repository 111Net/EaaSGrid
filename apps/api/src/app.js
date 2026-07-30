const express = require("express");

const app = express();

/*
|--------------------------------------------------------------------------
| Routes
|--------------------------------------------------------------------------
*/

const routes = require("./routes");
const authRoutes = require("./auth/auth.routes");
const protectedRoutes = require("./routes/protected.routes");
const dashboardRoutes = require("./dashboard/dashboard.routes");

/*
|--------------------------------------------------------------------------
| Middleware
|--------------------------------------------------------------------------
*/

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");

const notFound = require("./middleware/notFound");
const errorHandler = require("./middleware/errorHandler");

/*
|--------------------------------------------------------------------------
| Core Middleware
|--------------------------------------------------------------------------
*/

app.use(corsMiddleware);

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.use(securityHeaders);

app.use(logger);

/*
|--------------------------------------------------------------------------
| Health
|--------------------------------------------------------------------------
*/

app.get("/api/v1/health", (req, res) => {
    res.json({
        status: "ok",
        service: "eaasgrid-api",
        timestamp: new Date().toISOString()
    });
});

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

app.use("/api/v1/auth", authRoutes);

app.use("/api/protected", protectedRoutes);

app.use("/api/v1/dashboard", dashboardRoutes);

app.use("/api/v1", routes);

/*
|--------------------------------------------------------------------------
| Error Handling
|--------------------------------------------------------------------------
*/



/*
|--------------------------------------------------------------------------
| Sprint 1 Commercial Platform Routes
|--------------------------------------------------------------------------
*/

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




// Sprint 3 Operational Intelligence Routes

app.use("/api/v1/devices",
require("./device/device.routes"));

app.use("/api/v1/telemetry",
require("./telemetry/telemetry.routes"));

app.use("/api/v1/operations",
require("./monitoring/operations.routes"));




// Sprint 4 AI Automation Routes

app.use("/api/v1/ai",
require("./ai/ai.routes"));

app.use("/api/v1/automation",
require("./automation/automation.routes"));




// Sprint 5 Enterprise Scale Routes

app.use("/api/v1/enterprise",
require("./enterprise/enterprise.routes"));

app.use("/api/v1/sla",
require("./sla/sla.routes"));

app.use("/api/v1/marketplace",
require("./marketplace/marketplace.routes"));

app.use("/api/v1/integrations",
require("./integrations/integrations.routes"));




// Sprint 6 Global Platform Expansion Routes

app.use("/api/v1/global",
require("./global/global.routes"));

app.use("/api/v1/datawarehouse",
require("./datawarehouse/datawarehouse.routes"));

app.use("/api/v1/ecosystem",
require("./ecosystem/ecosystem.routes"));

app.use("/api/v1/mobile",
require("./mobile/mobile.routes"));




// Sprint 7 Autonomous Enterprise Routes

app.use("/api/v1/agents",
require("./agents/agents.routes"));

app.use("/api/v1/digital-twin",
require("./digital-twin/digital.routes"));

app.use("/api/v1/healing",
require("./healing/healing.routes"));

app.use("/api/v1/compliance",
require("./compliance/compliance.routes"));




// Sprint 8 Global Autonomous Cloud Routes

app.use("/api/v1/cloud",
require("./cloud/cloud.routes"));

app.use("/api/v1/optimisation",
require("./optimisation/optimisation.routes"));

app.use("/api/v1/disaster-recovery",
require("./disaster-recovery/dr.routes"));




// Sprint 9 Production Route

app.use(
"/api/v1/production",
require("./production/production.routes")
);




// Sprint 10 Enterprise Growth Routes

app.use(
"/api/v1/enterprise",
require("./enterprise/enterprise.routes")
);




// Sprint 11 Global Expansion Routes

app.use(
"/api/v1/global",
require("./global/global.routes")
);




// Sprint 12 Autonomous AI Routes

app.use(
"/api/v1/ai",
require("./ai/ai.routes")
);


app.use(notFound);

app.use(errorHandler);

module.exports = app;