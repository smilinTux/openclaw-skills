#!/bin/bash
# Discord bot restart script

BOT_DIR="${1:-$(pwd)}"

echo "🔄 Restarting Discord Bot..."
echo "📁 Bot Directory: $BOT_DIR"

# Stop the bot
./bot-stop.sh "$BOT_DIR"

# Wait a moment
echo "⏳ Waiting 2 seconds..."
sleep 2

# Start the bot
./bot-start.sh "$BOT_DIR"

echo "✅ Restart complete!"