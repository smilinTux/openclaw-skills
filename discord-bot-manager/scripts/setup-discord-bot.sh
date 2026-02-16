#!/bin/bash
# Initial Discord bot project setup

set -e

BOT_NAME="${1:-my-discord-bot}"
BOT_DIR="${2:-$BOT_NAME}"

echo "🤖 Discord Bot Project Setup"
echo "============================="
echo "📁 Bot Name: $BOT_NAME"
echo "📂 Directory: $BOT_DIR"

# Create bot directory
if [ -d "$BOT_DIR" ]; then
    echo "❓ Directory $BOT_DIR already exists. Continue? (y/N)"
    read -r CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled"
        exit 1
    fi
fi

mkdir -p "$BOT_DIR"
cd "$BOT_DIR"

echo "📦 Initializing npm project..."

# Create package.json if it doesn't exist
if [ ! -f "package.json" ]; then
    cat > package.json <<EOF
{
  "name": "$BOT_NAME",
  "version": "1.0.0",
  "description": "A Discord bot built with discord.js",
  "main": "bot.js",
  "scripts": {
    "start": "node bot.js",
    "dev": "node --watch bot.js"
  },
  "keywords": ["discord", "bot"],
  "author": "",
  "license": "MIT",
  "dependencies": {
    "discord.js": "^14.14.1"
  }
}
EOF
fi

echo "📥 Installing dependencies..."
npm install

# Create .env template if it doesn't exist
if [ ! -f ".env" ]; then
    echo "🔐 Creating .env template..."
    cat > .env <<EOF
# Discord Bot Token (get from https://discord.com/developers/applications)
DISCORD_TOKEN=your_bot_token_here

# Guild ID (optional, for guild-specific commands)
GUILD_ID=your_guild_id_here
EOF
    echo "⚠️  Please edit .env and add your bot token!"
fi

# Create logs directory
mkdir -p logs

# Create basic bot.js if it doesn't exist
if [ ! -f "bot.js" ]; then
    echo "🤖 Creating basic bot template..."
    cat > bot.js <<'EOF'
const { Client, GatewayIntentBits, Events } = require('discord.js');
require('dotenv').config();

// Create a new client instance
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
    ],
});

// When the client is ready, run this code once
client.once(Events.ClientReady, readyClient => {
    console.log(`✅ ${readyClient.user.tag} is online!`);
    console.log(`🛡️ Managing ${client.guilds.cache.size} server(s)`);
    if (client.guilds.cache.size > 0) {
        const firstGuild = client.guilds.cache.first();
        console.log(`💬 Server: ${firstGuild.name} (${firstGuild.id})`);
    }
});

// Handle messages
client.on(Events.MessageCreate, message => {
    // Ignore messages from bots
    if (message.author.bot) return;

    // Simple ping command
    if (message.content.toLowerCase() === '!ping') {
        message.reply('🏓 Pong!');
    }

    // Bot info command
    if (message.content.toLowerCase() === '!info') {
        message.reply(`🤖 I'm ${client.user.tag}, online and ready!`);
    }
});

// Handle errors
client.on(Events.Error, error => {
    console.error('❌ Discord client error:', error);
});

// Log in to Discord
client.login(process.env.DISCORD_TOKEN);
EOF
fi

# Add dotenv dependency if not present
if ! grep -q "dotenv" package.json; then
    echo "📥 Installing dotenv..."
    npm install dotenv
fi

# Copy management scripts from skill
SKILL_SCRIPTS="/home/cbrd21/clawd/skills/discord-bot-manager/scripts"
if [ -d "$SKILL_SCRIPTS" ]; then
    echo "📋 Copying management scripts..."
    for script in bot-start.sh bot-stop.sh bot-status.sh bot-restart.sh install-systemd-service.sh; do
        if [ -f "$SKILL_SCRIPTS/$script" ]; then
            cp "$SKILL_SCRIPTS/$script" .
            chmod +x "$script"
        fi
    done
fi

echo ""
echo "✅ Discord Bot Setup Complete!"
echo ""
echo "🔧 Next Steps:"
echo "1. Edit .env and add your Discord bot token"
echo "2. Test the bot: npm start"
echo "3. Deploy with management scripts:"
echo "   • ./bot-start.sh     - Start in background"
echo "   • ./bot-status.sh    - Check status"
echo "   • ./bot-stop.sh      - Stop bot"
echo "   • ./install-systemd-service.sh - Install as service"
echo ""
echo "📂 Project Structure:"
echo "  $BOT_DIR/"
echo "  ├── bot.js           - Main bot code"
echo "  ├── package.json     - Dependencies"
echo "  ├── .env             - Configuration (add token!)"
echo "  ├── logs/            - Bot logs"
echo "  └── bot-*.sh         - Management scripts"
echo ""
echo "🔗 Get your bot token: https://discord.com/developers/applications"