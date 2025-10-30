# Use the official Node.js 18 Alpine image
FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    ffmpeg

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy application source
COPY . .

# Build the application
RUN npm run build

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
USER node


# Environment variables should be provided at runtime (e.g., via docker-compose.yaml)

# Expose port (adjust if needed based on your application)
EXPOSE 3000


# Start the application
CMD ["elizaos", "start"]