# backend/Dockerfile
FROM node:20-alpine

# Set non-root working directory and permissions
WORKDIR /app

# Copy package manifests and set ownership
COPY --chown=node:node package*.json ./

# Install production dependencies as non-root node user
RUN npm ci --only=production

# Copy application source with node user ownership
COPY --chown=node:node . .

# Environment defaults
ENV NODE_ENV=production
ENV PORT=5000

# Switch to unprivileged non-root user
USER node

EXPOSE 5000

CMD ["node", "src/index.js"]
