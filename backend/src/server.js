const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const apiKeyMiddleware = require("./middleware/apiKey");
const robotsRouter = require("./routes/robots");
const { PORT } = require("./config");
const { readRobots } = require("./dataStore");
const { swaggerUi, specs } = require("./swagger");

const app = express();

app.use(cors());
app.use(express.json({ limit: "1mb" }));
app.use(morgan("dev"));

// Swagger UI - available without API Key
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(specs));

app.get("/health", async (_req, res) => {
  try {
    const robots = await readRobots();
    return res.status(200).json({
      status: "ok",
      robots: robots.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

app.use(apiKeyMiddleware);
app.use("/robots", robotsRouter);

app.use((req, res) => {
  return res.status(404).json({
    error: "Route not found",
    message: `No route for ${req.method} ${req.originalUrl}`,
  });
});

app.use((error, _req, res, _next) => {
  return res.status(500).json({
    error: "Internal server error",
    message: error.message,
  });
});

app.listen(PORT, () => {
  console.log(`ROBOX backend running on http://localhost:${PORT}`);
});
