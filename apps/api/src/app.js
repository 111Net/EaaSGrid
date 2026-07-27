const express = require("express");

const app = express();

const routes = require("./routes");
const authRoutes = require("./auth/auth.routes");
const protectedRoutes = require("./routes/protected.routes");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");
const logger = require("./middleware/logger");

const notFound = require("./middleware/notFound");
const errorHandler = require("./middleware/errorHandler");


/*
 Core middleware
*/

app.use(corsMiddleware);

app.use(express.json());

app.use(securityHeaders);

app.use(logger);


/*
 Routes
*/

app.use("/api/v1/auth", authRoutes);

app.use("/api/protected", protectedRoutes);

app.use("/api/v1", routes);


/*
 Error handling
*/

app.use(notFound);

app.use(errorHandler);


module.exports = app;
