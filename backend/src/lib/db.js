import mongoose from "mongoose";

export const connectDB = async (retries = 5, delay = 3000) => {
  const uri = process.env.MONGODB_URI;
  if (!uri) {
    console.error("MONGODB_URI is not defined. Set it in your .env or environment.");
    process.exit(1);
  }

  const mongooseOptions = {
    maxPoolSize: parseInt(process.env.DB_MAX_POOL_SIZE || "50", 10),
    minPoolSize: parseInt(process.env.DB_MIN_POOL_SIZE || "10", 10),
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
    family: 4,
    autoIndex: process.env.NODE_ENV !== "production",
  };

  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const conn = await mongoose.connect(uri, mongooseOptions);
      console.log(`✅ MongoDB connected successfully: ${conn.connection.host}`);
      return conn;
    } catch (error) {
      console.error(`⚠️ MongoDB connection attempt ${attempt}/${retries} failed: ${error.message}`);
      if (attempt === retries) {
        console.error("❌ Exceeded maximum MongoDB connection retries. Exiting.");
        process.exit(1);
      }
      await new Promise((resolve) => setTimeout(resolve, delay));
    }
  }
};

