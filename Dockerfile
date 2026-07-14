FROM node:22

# Install system dependencies (curl for health check, openssl for Prisma, and sqlite3 for DB seeding)
RUN apt-get update && apt-get install -y curl openssl sqlite3 && rm -rf /var/lib/apt/lists/*

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
