FROM node:22-slim

# Install system dependencies (curl for health check, openssl for Prisma, and sqlite3 for DB seeding)
RUN apt-get update && apt-get install -y curl openssl sqlite3 && rm -rf /var/lib/apt/lists/*

# Optimize V8 garbage collection to fit in Render's 512MB RAM limit
ENV NODE_OPTIONS="--max-old-space-size=350"

# Install omniroute globally
RUN npm install -g omniroute --unsafe-perm

# Set up working directory
WORKDIR /app

# Copy and configure entrypoint
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
