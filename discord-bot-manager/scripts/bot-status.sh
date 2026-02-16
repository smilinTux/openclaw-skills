#!/bin/bash
# Discord bot status checker

BOT_DIR="${1:-$(pwd)}"
PID_FILE="$BOT_DIR/bot.pid"
LOG_DIR="$BOT_DIR/logs"

cd "$BOT_DIR"

echo "🔍 Discord Bot Status Check"
echo "=================================="

# Check PID file
if [ ! -f "$PID_FILE" ]; then
    echo "❌ Status: NOT RUNNING (no PID file)"
    echo "🚀 Start with: ./bot-start.sh"
    exit 1
fi

BOT_PID=$(cat "$PID_FILE")
echo "📄 PID File: $PID_FILE (PID: $BOT_PID)"

# Check if process is actually running
if ! kill -0 "$BOT_PID" 2>/dev/null; then
    echo "❌ Status: NOT RUNNING (process not found)"
    echo "🧹 Cleaning up stale PID file..."
    rm -f "$PID_FILE"
    echo "🚀 Start with: ./bot-start.sh"
    exit 1
fi

echo "✅ Status: RUNNING"
echo "🆔 Process ID: $BOT_PID"

# Get process info
if command -v ps >/dev/null 2>&1; then
    PROC_INFO=$(ps -o pid,ppid,cmd,etime,pcpu,pmem -p "$BOT_PID" 2>/dev/null | tail -n 1)
    if [ -n "$PROC_INFO" ]; then
        echo "📊 Process: $PROC_INFO"
        # Extract just the elapsed time
        UPTIME=$(echo "$PROC_INFO" | awk '{print $4}')
        echo "⏱️  Uptime: $UPTIME"
    fi
fi

echo ""
echo "📋 Recent Log Output:"
echo "===================="

# Find latest log file
if [ -d "$LOG_DIR" ]; then
    LATEST_LOG=$(ls -t "$LOG_DIR"/bot-*.log 2>/dev/null | head -n 1)
    if [ -n "$LATEST_LOG" ]; then
        echo "📂 Latest log: $LATEST_LOG"
        echo "👁️  Last 10 lines:"
        echo ""
        tail -10 "$LATEST_LOG" 2>/dev/null || echo "Could not read log file"
    else
        echo "📂 No log files found in $LOG_DIR"
    fi
else
    echo "📂 Log directory not found: $LOG_DIR"
fi

echo ""
echo "🎯 Bot Management Commands:"
echo "  ./bot-start.sh   - Start the bot"
echo "  ./bot-stop.sh    - Stop the bot"
echo "  ./bot-restart.sh - Restart the bot"
echo "  ./bot-status.sh  - Check status (this command)"