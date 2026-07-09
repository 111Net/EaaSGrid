const express = require("express");

const app = express();

const routes = require("./routes");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");

const notFound = require("./middleware/notFound");
const errorHandler = require("./middleware/errorHandler");

app.use(corsMiddleware);
app.use(securityHeaders);
app.use(logger);
app.use(express.json());

app.use("/api/v1", routes);

// 404 handler
app.use(notFound);

// Error handler (must be last)
app.use(errorHandler);

module.exports = app;
