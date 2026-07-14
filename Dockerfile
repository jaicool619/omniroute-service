FROM node:18-slim

# Install system dependencies (curl for health check, and python3/make/g++ for compiling better-sqlite3 if needed)
RUN apt-get update && apt-get install -y curl python3 make g++ && rm -rf /var/lib/apt/lists/*

# Install omniroute globally
RUN npm install -g omniroute --unsafe-perm

# Set up working directory
WORKDIR /app

# Copy and configure entrypoint
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Render binds to $PORT dynamically
ENV PORT=20128
EXPOSE 20128

ENTRYPOINT ["./entrypoint.sh"]
