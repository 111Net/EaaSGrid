const app = require("./app");

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    service: "eaasgrid-api"
  });
});

const PORT = process.env.PORT || 4000;

app.listen(PORT, () => {
  console.log(`EAASGrid API running on port ${PORT}`);
});
