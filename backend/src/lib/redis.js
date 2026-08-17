import Redis from "ioredis";

const redisHost = process.env.REDIS_HOST || "localhost";
const redisPort = parseInt(process.env.REDIS_PORT || "6379", 10);
const redisPassword = process.env.REDIS_PASSWORD || undefined;

let redisClient = null;
let pubClient = null;
let subClient = null;
let isRedisAvailable = false;

const redisOptions = {
  host: redisHost,
  port: redisPort,
  password: redisPassword,
  lazyConnect: true,
  maxRetriesPerRequest: 3,
  retryStrategy(times) {
    if (times > 3) {
      console.warn("⚠️ Redis connection retries exceeded. Falling back to in-memory mode.");
      return null;
    }
    return Math.min(times * 200, 1000);
  },
};

export async function initRedis() {
  if (process.env.NODE_ENV === "test" && !process.env.REDIS_HOST) {
    return { isRedisAvailable: false, redisClient: null, pubClient: null, subClient: null };
  }

  try {
    redisClient = new Redis(redisOptions);
    pubClient = new Redis(redisOptions);
    subClient = pubClient.duplicate();

    redisClient.on("error", (err) => {
      console.warn("⚠️ Redis client error:", err.message);
      isRedisAvailable = false;
    });

    pubClient.on("error", (err) => {
      console.warn("⚠️ Redis pubClient error:", err.message);
      isRedisAvailable = false;
    });

    subClient.on("error", (err) => {
      console.warn("⚠️ Redis subClient error:", err.message);
      isRedisAvailable = false;
    });

    await Promise.all([
      redisClient.connect(),
      pubClient.connect(),
      subClient.connect(),
    ]);

    isRedisAvailable = true;
    console.log(`✅ Connected to Redis at ${redisHost}:${redisPort}`);
  } catch (error) {
    console.warn(`⚠️ Could not connect to Redis at ${redisHost}:${redisPort}: ${error.message}. Standard fallback enabled.`);
    isRedisAvailable = false;
  }

  return { isRedisAvailable, redisClient, pubClient, subClient };
}

export function getRedisClients() {
  return { isRedisAvailable, redisClient, pubClient, subClient };
}

// Helpers for Online Users state tracking in Redis
const ONLINE_USERS_KEY = "chat:online_users";

export async function addOnlineUser(userId, socketId) {
  if (isRedisAvailable && redisClient) {
    try {
      await redisClient.sadd(ONLINE_USERS_KEY, userId.toString());
      await redisClient.hset(`chat:user_socket:${userId}`, socketId, "connected");
    } catch (err) {
      console.warn("Failed to add online user in Redis:", err.message);
    }
  }
}

export async function removeOnlineUser(userId, socketId) {
  if (isRedisAvailable && redisClient) {
    try {
      if (socketId) {
        await redisClient.hdel(`chat:user_socket:${userId}`, socketId);
        const remainingSockets = await redisClient.hlen(`chat:user_socket:${userId}`);
        if (remainingSockets === 0) {
          await redisClient.srem(ONLINE_USERS_KEY, userId.toString());
        }
      } else {
        await redisClient.srem(ONLINE_USERS_KEY, userId.toString());
      }
    } catch (err) {
      console.warn("Failed to remove online user from Redis:", err.message);
    }
  }
}

export async function getOnlineUsers() {
  if (isRedisAvailable && redisClient) {
    try {
      return await redisClient.smembers(ONLINE_USERS_KEY);
    } catch (err) {
      console.warn("Failed to get online users from Redis:", err.message);
    }
  }
  return null;
}
