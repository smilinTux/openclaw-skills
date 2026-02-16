#!/bin/bash
# Install Discord bot as systemd service

set -e

BOT_DIR="${1:-$(pwd)}"
BOT_NAME="${2:-discord-bot}"
SERVICE_NAME="$BOT_NAME.service"

cd "$BOT_DIR"

echo "🤖 $BOT_NAME Systemd Service Installation"
echo "============================================="

# Ensure we're in a bot directory
if [ ! -f "package.json" ] || [ ! -f "bot.js" ]; then
    echo "❌ Error: Not in a Discord bot directory"
    echo "   Expected files: package.json, bot.js"
    exit 1
fi

echo "🔧 Making scripts executable..."
chmod +x ./bot-*.sh 2>/dev/null || true

# Create systemd service file
SERVICE_FILE="/tmp/${SERVICE_NAME}"
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=$BOT_NAME - Discord Bot
After=network.target
Wants=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$BOT_DIR
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=3
StandardOutput=append:$BOT_DIR/logs/systemd.log
StandardError=append:$BOT_DIR/logs/systemd-error.log
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

echo "📦 Installing systemd service..."

# Copy service file (requires sudo)
if ! sudo cp "$SERVICE_FILE" "/etc/systemd/system/$SERVICE_NAME"; then
    echo "❌ Failed to install service file"
    echo "   Make sure you have sudo privileges"
    exit 1
fi

# Clean up temp file
rm -f "$SERVICE_FILE"

echo "🔄 Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "⚡ Enabling service to start on boot..."
sudo systemctl enable "$SERVICE_NAME"

# Create log directory
mkdir -p logs

echo "🚀 Starting $BOT_NAME service..."
sudo systemctl start "$SERVICE_NAME"

# Wait a moment for service to start
sleep 3

echo ""
echo "📊 Service Status:"
sudo systemctl status "$SERVICE_NAME" --no-pager

echo ""
echo "✅ Installation Complete!"
echo ""
echo "🎯 Service Management Commands:"
echo "  sudo systemctl start $SERVICE_NAME     - Start bot"
echo "  sudo systemctl stop $SERVICE_NAME      - Stop bot"
echo "  sudo systemctl restart $SERVICE_NAME   - Restart bot"
echo "  sudo systemctl status $SERVICE_NAME    - Check status"
echo "  sudo journalctl -u $SERVICE_NAME -f    - View live logs"
echo ""
echo "📂 Log Files:"
echo "  $BOT_DIR/logs/systemd.log       - Standard output"
echo "  $BOT_DIR/logs/systemd-error.log - Error output"
echo ""
echo "🤖 Your $BOT_NAME is now running as a system service!"
echo "   It will automatically start on boot and restart if it crashes."