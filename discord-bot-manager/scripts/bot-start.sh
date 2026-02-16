#!/bin/bash
# Discord bot startup script

set -e

# Configuration
BOT_DIR="${1:-$(pwd)}"
LOG_DIR="$BOT_DIR/logs"
PID_FILE="$BOT_DIR/bot.pid"

cd "$BOT_DIR"

echo "🚀 Starting Discord Bot..."
echo "📁 Bot Directory: $BOT_DIR"
echo "📋 Logs: $LOG_DIR"

# Stop existing bot if running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "🔄 Stopping existing bot (PID: $OLD_PID)"
        kill "$OLD_PID" 2>/dev/null || true
        sleep 2
    fi
fi

# Create log directory
mkdir -p "$LOG_DIR"

# Generate timestamped log file
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
LOG_FILE="$LOG_DIR/bot-$TIMESTAMP.log"

echo "⚡ Launching Discord Bot..."

# Start bot in background with output redirection
nohup npm start > "$LOG_FILE" 2>&1 &
BOT_PID=$!

# Save PID
echo "$BOT_PID" > "$PID_FILE"

echo "✅ Discord Bot started!"
echo "🆔 Process ID: $BOT_PID"
echo "📋 Log: $LOG_FILE"
echo "🔍 Check status: ./bot-status.sh"
echo "⏹️  Stop bot: ./bot-stop.sh"

# Show initial log output (with error handling)
echo ""
echo "📋 Initial log output:"
sleep 2
if [ -f "$LOG_FILE" ]; then
    tail -10 "$LOG_FILE" 2>/dev/null || echo "Log file not ready yet"
else
    echo "Log file not created yet"
fi