# Build stage
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage - Unprivileged Non-root Nginx
FROM nginxinc/nginx-unprivileged:alpine

# Temporarily switch to root to remove default static files owned by root
USER root
RUN rm -rf /usr/share/nginx/html/*
# Switch back to unprivileged nginx user (UID 101)
USER 101

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy React build with unprivileged nginx user ownership
COPY --from=build --chown=101:101 /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]