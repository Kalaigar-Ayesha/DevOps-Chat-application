import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import cors from "cors";
import helmet from "helmet";
import rateLimit from "express-rate-limit";

import authRoutes from "./routes/auth.route.js";
import messageRoutes from "./routes/message.route.js";
import { register } from "./lib/metrics.js";
import logger, { logHttpRequest } from "./lib/logger.js";

dotenv.config();

const app = express();

// Security Headers via Helmet.js
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "https://res.cloudinary.com"],
        connectSrc: ["'self'", "ws:", "wss:"],
      },
    },
    crossOriginEmbedderPolicy: false,
  })
);

app.use(express.json());
app.use(cookieParser());

// Rate Limiting (DDoS & Brute Force Mitigation)
const isTestEnv = process.env.NODE_ENV === "test";

const globalApiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per 15 minutes
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => isTestEnv,
  message: { error: "Too many requests from this IP, please try again after 15 minutes." },
});

const authRateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // 20 login/signup attempts per 15 minutes
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => isTestEnv,
  message: { error: "Too many authentication attempts, please try again later." },
});

// Middleware to track request metrics
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    const route = req.route ? req.route.path : req.path;
    
    logHttpRequest(req.method, route, res.statusCode, duration);
  });
  
  next();
});

// Strict CORS Whitelist Configuration
const allowedOrigins = [
  process.env.CLIENT_URL,
  ...(process.env.CORS_ORIGIN?.split(",").map((s) => s.trim()).filter(Boolean) || []),
  "http://localhost:5173",
  "http://localhost:3000",
].filter(Boolean);

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin) || isTestEnv) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS security policy"));
      }
    },
    credentials: true,
  })
);

app.get("/health", (req, res) => {
  res.status(200).send("ok");
});

// Test route
app.get("/test", (req, res) => {
  res.status(200).send("test route works");
});

// Add metrics endpoint
app.get("/metrics", async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (error) {
    logger.error('Error generating metrics', { error: error.message });
    res.status(500).end();
  }
});

// Apply rate limiters to routes
app.use("/api/", globalApiLimiter);
app.use("/api/auth", authRateLimiter, authRoutes);
app.use("/api/messages", messageRoutes);

export { app };
