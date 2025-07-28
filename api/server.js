import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { PrismaClient } from "@prisma/client";
import authRoutes from "./routes/auth.routes.js";
import hotspotRoutes from "./routes/hotspotRoutes.js";
import authMiddleware from "./middleware/authMiddleware.js";

const prisma = new PrismaClient();

const app = express();
const allowedOrigins = [
  "http://localhost:3000",
  "http://localhost:41881", 
];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "X-Requested-With",
    "Accept",
  ],
  exposedHeaders: ["Authorization", "X-Total-Count"],
  credentials: true,
  maxAge: 86400, // 24 hours
};

// Apply CORS middleware
app.use(cors(corsOptions));
app.options("*", cors(corsOptions));

app.use(helmet());
app.use(morgan("dev"));
app.use(express.json({ limit: "10kb" }));

// ======================
// API Routes
// ======================
app.use("/auth", authRoutes);
app.use("/hotspots", hotspotRoutes);

// ======================
// Error Handling
// ======================
app.use(authMiddleware);

// ======================
// Server Initialization
// ======================
const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, async () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🔄 Connecting to database...`);
  try {
    await prisma.$connect();
    console.log("✅ Database connected");
  } catch (error) {
    console.error("❌ Database connection error:", error);
  }
});

// ======================
// Graceful Shutdown
// ======================
const shutdown = async () => {
  console.log("🛑 Shutting down server...");
  await prisma.$disconnect();
  server.close(() => {
    console.log("✅ Server closed");
    process.exit(0);
  });
};

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);

export default app;
