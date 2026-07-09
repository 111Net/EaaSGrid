const express = require("express");

const app = express();

const routes = require("./routes");

const corsMiddleware = require("./middleware/cors");
const securityHeaders = require("./middleware/security");

app.use(corsMiddleware);

app.use(securityHeaders);

app.use(express.json());

app.use("/api/v1", routes);

module.exports = app;
