#!/bin/bash
echo "[SYSTEM] Configuring Standalone OmniRoute..."

# Configure OmniRoute directory
OMNI_DIR="$HOME/.omniroute"
OMNI_ENV="$OMNI_DIR/.env"
OMNI_DB="$OMNI_DIR/storage.sqlite"

mkdir -p "$OMNI_DIR"

# Write provider config using the GEMINI_API_KEY environment variable
cat > "$OMNI_ENV" << OMNI_EOF
GOOGLE_AI_API_KEY=${GEMINI_API_KEY}
GEMINI_API_KEY=${GEMINI_API_KEY}
GROQ_API_KEY=${GROQ_API_KEY}
OMNIROUTE_AUTO_FREE_FALLBACK_TO_FULL_POOL=true
OMNI_EOF

echo "[SYSTEM] Standalone OmniRoute config written to $OMNI_ENV"

echo "[SYSTEM] Launching OmniRoute serve on port ${PORT:-20128}..."
omniroute serve --host 0.0.0.0 --port ${PORT:-20128} --no-open &
SERVER_PID=$!

echo "[SYSTEM] Waiting for OmniRoute server to be ready on port ${PORT:-20128}..."
for i in $(seq 1 60); do
    if curl -s "http://localhost:${PORT:-20128}/api/monitoring/health" > /dev/null || curl -s "http://localhost:${PORT:-20128}/v1" > /dev/null; then
        echo "[SYSTEM] Server is ready! Seeding API Key..."
        sqlite3 -cmd ".timeout 5000" "$OMNI_DB" "INSERT OR IGNORE INTO api_keys (id, name, key, created_at, no_log) VALUES ('default-anaya-key', 'Anaya Bot Key', 'sk-or-omniroute', datetime('now'), 0);"
        echo "[SYSTEM] API Key 'sk-or-omniroute' seeded successfully!"
        break
    fi
    sleep 1.5
done

# Bring server process to foreground
wait $SERVER_PID
