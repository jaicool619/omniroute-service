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
STORAGE_ENCRYPTION_KEY=anaya-bot-key-2024
OMNI_EOF

echo "[SYSTEM] Standalone OmniRoute config written to $OMNI_ENV"

# Clean stale SQLite database on start to ensure encryption syncs
if [ -f "$OMNI_DB" ]; then
    echo "[SYSTEM] Cleaning old database..."
    rm -f "$OMNI_DB"
fi

echo "[SYSTEM] Launching OmniRoute serve on port $PORT..."
exec omniroute serve --port $PORT --no-open
