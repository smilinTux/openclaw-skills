# Discord API Setup Guide

## Creating a Discord Application

1. **Visit Discord Developer Portal**
   - Go to https://discord.com/developers/applications
   - Click "New Application"
   - Enter your bot name
   - Click "Create"

2. **Configure Bot Settings**
   - Navigate to "Bot" section in left sidebar
   - Click "Add Bot" if not already created
   - Copy the bot token (keep this secret!)
   - Enable any required privileged intents:
     - Server Members Intent (for member info)
     - Message Content Intent (for reading message content)

3. **Set Bot Permissions**
   - Go to "OAuth2" > "URL Generator"
   - Select "bot" scope
   - Select required bot permissions:
     - Send Messages
     - Read Messages
     - Manage Messages (for moderation)
     - Add Reactions
     - Use Slash Commands
   - Copy the generated URL to invite the bot

## Required Intents

```javascript
const { Client, GatewayIntentBits } = require('discord.js');

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,           // Guild info
        GatewayIntentBits.GuildMessages,     // Message events  
        GatewayIntentBits.MessageContent,    // Message content (privileged)
        GatewayIntentBits.GuildMembers,      // Member info (privileged)
    ],
});
```

## Environment Variables

Always store sensitive data in `.env`:

```bash
# Discord Bot Token
DISCORD_TOKEN=your_bot_token_here

# Guild ID (for guild-specific commands)
GUILD_ID=123456789012345678

# Optional: Channel IDs
WELCOME_CHANNEL=123456789012345678
LOG_CHANNEL=123456789012345678
```

## Common Setup Issues

**Bot not responding:**
- Check token is correct
- Verify bot has Send Messages permission
- Check required intents are enabled

**"Missing Permissions" errors:**
- Review bot role hierarchy
- Ensure bot has required channel permissions
- Check privileged intents in Developer Portal

**Rate limiting:**
- Discord.js handles most rate limiting
- Avoid rapid bulk operations
- Use `await` for sequential API calls