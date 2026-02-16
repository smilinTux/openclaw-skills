#!/bin/bash
# Discord bot stop script

BOT_DIR="${1:-$(pwd)}"
PID_FILE="$BOT_DIR/bot.pid"

cd "$BOT_DIR"

echo "⏹️  Stopping Discord Bot..."

# Check if PID file exists
if [ ! -f "$PID_FILE" ]; then
    echo "📄 No PID file found at $PID_FILE"
    echo "❓ Bot may not be running or was started manually"
    echo "🧹 Cleaning up any remaining bot processes..."
    # Kill any npm/node processes that might be bots
    pkill -f "npm start" 2>/dev/null || true
    pkill -f "node.*bot\.js" 2>/dev/null || true
    echo "✅ Stop complete"
    exit 0
fi

BOT_PID=$(cat "$PID_FILE")

# Check if process exists
if ! kill -0 "$BOT_PID" 2>/dev/null; then
    echo "📄 PID file exists but process $BOT_PID is not running"
    echo "🧹 Cleaning up stale PID file..."
    rm -f "$PID_FILE"
    echo "✅ Stop complete (was already stopped)"
    exit 0
fi

echo "🔄 Terminating bot process (PID: $BOT_PID)"

# Try graceful shutdown first
kill -TERM "$BOT_PID" 2>/dev/null

# Wait up to 10 seconds for graceful shutdown
for i in {1..10}; do
    if ! kill -0 "$BOT_PID" 2>/dev/null; then
        echo "✅ Bot stopped gracefully"
        rm -f "$PID_FILE"
        break
    fi
    echo "⏳ Waiting for graceful shutdown... ($i/10)"
    sleep 1
done

# Force kill if still running
if kill -0 "$BOT_PID" 2>/dev/null; then
    echo "💥 Force killing bot process..."
    kill -KILL "$BOT_PID" 2>/dev/null
    sleep 1
    if kill -0 "$BOT_PID" 2>/dev/null; then
        echo "❌ Could not stop bot process $BOT_PID"
        exit 1
    fi
    rm -f "$PID_FILE"
fi

echo "✅ Bot stopped successfully"
echo "🧹 Cleaning up any remaining bot processes..."
pkill -f "npm start" 2>/dev/null || true
pkill -f "node.*bot\.js" 2>/dev/null || true
echo "✅ Stop complete"