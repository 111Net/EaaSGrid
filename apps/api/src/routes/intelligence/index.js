const express = require("express");

const router = express.Router();

const metrics = require("../../intelligence/metrics/metrics.service");
const activity = require("../../intelligence/activity/activity.service");
const lifecycle = require("../../intelligence/lifecycle/lifecycle.service");
const health = require("../../intelligence/health/service-health");


router.get("/metrics", async (req, res) => {
    try {
        res.json({
            success: true,
            data: await metrics.getMetrics()
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});


router.get("/activity", async (req, res) => {
    try {
        res.json({
            success: true,
            data: await activity.getActivity()
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});


router.get("/lifecycle", async (req, res) => {
    try {
        res.json({
            success: true,
            data: await lifecycle.getLifecycle()
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});


router.get("/services", (req, res) => {
    res.json({
        success: true,
        data: health.getHealth()
    });
});


module.exports = router;
