# Multi-stage build for efficiency
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY vue/package*.json ./vue/

# Install all dependencies (both prod & dev)
RUN npm ci

# Install Vue dependencies separately for layer caching
WORKDIR /app/vue
RUN npm ci

# Copy all source files
WORKDIR /app
COPY . .

# Build application
RUN npm run Build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Copy package files and production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built Vue app from builder
COPY --from=builder /app/vue/dist ./vue/dist
COPY --from=builder /app/vue/node_modules ./vue/node_modules
COPY --from=builder /app/vue/assets ./vue/assets
COPY --from=builder /app/vue/public ./vue/public

# Copy server source code
COPY --from=builder /app/*.js ./
COPY --from=builder /app/sortOpts.json ./
COPY --from=builder /app/swagger-specs.json ./
COPY --from=builder /app/node_modules ./node_modules

# Expose the port your app runs on
EXPOSE 63355

# Start the application
CMD ["npm", "start"]