import { Server } from "socket.io";
import { createAdapter } from "@socket.io/redis-adapter";
import http from "http";
import { initRedis, addOnlineUser, removeOnlineUser, getOnlineUsers } from "./redis.js";

// Global variables for socket management
let app, server;
let userSocketMap = {};
let io;

export function getReceiverSocketId(userId) {
  return userId ? userId.toString() : null;
}

export function getIO() {
  return io;
}

// Export io directly for backward compatibility
export { io };

export async function initializeSocket(expressApp) {
  app = expressApp;
  server = http.createServer(app);

  const socketOrigins =
    process.env.NODE_ENV === "production"
      ? "*"
      : (process.env.CORS_ORIGIN?.split(",").map((s) => s.trim()).filter(Boolean) ?? [
          "http://localhost:5173",
        ]);

  io = new Server(server, {
    cors: {
      origin: socketOrigins,
    },
  });

  // Attach Redis adapter if Redis is available
  const { isRedisAvailable, pubClient, subClient } = await initRedis();
  if (isRedisAvailable && pubClient && subClient) {
    io.adapter(createAdapter(pubClient, subClient));
    console.log("🚀 Socket.io Redis Adapter configured for horizontal scaling.");
  }

  async function broadcastOnlineUsers() {
    const redisOnlineUsers = await getOnlineUsers();
    if (redisOnlineUsers) {
      io.emit("getOnlineUsers", redisOnlineUsers);
    } else {
      io.emit("getOnlineUsers", Object.keys(userSocketMap));
    }
  }

  io.on("connection", async (socket) => {
    console.log("A user connected", socket.id);

    const userId = socket.handshake.query.userId;
    if (userId) {
      const userStr = userId.toString();
      userSocketMap[userStr] = socket.id;
      socket.join(userStr); // Join room named by userId for cross-pod messaging
      await addOnlineUser(userStr, socket.id);
    }

    await broadcastOnlineUsers();

    socket.on("disconnect", async () => {
      console.log("A user disconnected", socket.id);
      if (userId) {
        const userStr = userId.toString();
        delete userSocketMap[userStr];
        await removeOnlineUser(userStr, socket.id);
      }
      await broadcastOnlineUsers();
    });
  });

  return { io, server };
}

