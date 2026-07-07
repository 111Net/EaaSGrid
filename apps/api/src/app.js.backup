require("dotenv").config();

const express = require("express");
const cors = require("cors");

const billingRoutes = require("./routes/billing");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/billing", billingRoutes);

module.exports = app;
