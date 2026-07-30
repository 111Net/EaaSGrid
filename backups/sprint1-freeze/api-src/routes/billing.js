const express = require("express");
const router = express.Router();

// Simple billing calculation engine (MVP)
function calculateBill(kwh, rate) {
  return kwh * rate;
}

// POST /api/billing/calculate
router.post("/calculate", (req, res) => {
  try {
    const { userId, kwh, rate } = req.body;

    if (!userId || !kwh || !rate) {
      return res.status(400).json({
        error: "userId, kwh, and rate are required"
      });
    }

    const amount = calculateBill(kwh, rate);

    res.json({
      userId,
      kwh,
      rate,
      amount,
      currency: "NGN",
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    res.status(500).json({
      error: "Billing calculation failed"
    });
  }
});

module.exports = router;
