const express = require("express");

const app = express();

const routes = require("./routes");

const notFound = require("./middleware/notFound");
const errorHandler = require("./middleware/errorHandler");


app.use(express.json());


app.use("/api/v1", routes);


// 404 handler
app.use(notFound);


// Global error handler
app.use(errorHandler);


module.exports = app;
