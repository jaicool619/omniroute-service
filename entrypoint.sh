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
OMNI_EOF

echo "[SYSTEM] Standalone OmniRoute config written to $OMNI_ENV"

echo "[SYSTEM] Launching OmniRoute serve on port $PORT..."
omniroute serve --port $PORT --no-open &
SERVER_PID=$!

echo "[SYSTEM] Waiting for database to initialize..."
for i in $(seq 1 40); do
    if [ -f "$OMNI_DB" ] && sqlite3 "$OMNI_DB" ".tables" | grep -q "api_keys"; then
        echo "[SYSTEM] Database initialized! Seeding API Key..."
        sqlite3 "$OMNI_DB" "INSERT OR IGNORE INTO api_keys (id, name, key, key_prefix, created_at, no_log) VALUES ('default-anaya-key', 'Anaya Bot Key', 'sk-or-omniroute', 'sk-or-', datetime('now'), 0);"
        echo "[SYSTEM] API Key 'sk-or-omniroute' seeded successfully!"
        break
    fi
    sleep 0.5
done

# Bring server process to foreground
wait $SERVER_PID
