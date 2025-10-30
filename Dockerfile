# Build stage
FROM node:18-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git

# Install bun
RUN npm install -g bun@1.0.22

WORKDIR /app

# Copy package files first for better caching
COPY package.json bun.lock* ./

# Install production dependencies only
RUN bun install --frozen-lockfile --production

# Copy the rest of the application
COPY . .

# Build the application
RUN bun run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache ffmpeg

# Install bun
RUN npm install -g bun@1.0.22

# Copy built files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .

# Create non-root user
RUN addgroup -S app && adduser -S app -G app
RUN chown -R app:app /app
USER app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["bun", "start"]
USER node


# Environment variables should be provided at runtime (e.g., via docker-compose.yaml)

# Expose port (adjust if needed based on your application)
EXPOSE 3000


# Start the application
CMD ["elizaos", "start"]