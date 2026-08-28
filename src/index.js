const express = require("express");

const app = express();
const PORT = 3000;
const APP_VERSION = process.env.APP_VERSION || "dev";

app.get("/", (req, res) => {
  res.json({ service: "hello-express", version: APP_VERSION });
});

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.get("/version", (req, res) => {
  res.json({ version: APP_VERSION });
});

app.listen(PORT, () => {
  console.log(`hello-express listening on port ${PORT}`);
});
