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
    console.log(`🚀 Starting ${readyClient.user.tag}...`);
    console.log(`✅ ${readyClient.user.tag} is online!`);
    console.log(`🛡️ Managing ${client.guilds.cache.size} server(s)`);
    
    if (client.guilds.cache.size > 0) {
        const guilds = client.guilds.cache.map(g => `${g.name} (${g.id})`);
        console.log(`💬 Servers: ${guilds.join(', ')}`);
    }
});

// Handle messages
client.on(Events.MessageCreate, message => {
    // Ignore messages from bots
    if (message.author.bot) return;

    // Simple ping command
    if (message.content.toLowerCase() === '!ping') {
        const startTime = Date.now();
        message.reply('🏓 Pong!').then(reply => {
            const endTime = Date.now();
            reply.edit(`🏓 Pong! \`${endTime - startTime}ms\``);
        });
    }

    // Bot info command
    if (message.content.toLowerCase() === '!info') {
        const uptime = formatUptime(process.uptime());
        const embed = {
            color: 0x0099ff,
            title: '🤖 Bot Information',
            fields: [
                { name: 'Bot', value: client.user.tag, inline: true },
                { name: 'Servers', value: client.guilds.cache.size.toString(), inline: true },
                { name: 'Uptime', value: uptime, inline: true }
            ],
            timestamp: new Date().toISOString(),
        };
        message.reply({ embeds: [embed] });
    }

    // Help command
    if (message.content.toLowerCase() === '!help') {
        const embed = {
            color: 0x00ff00,
            title: '📋 Available Commands',
            description: 'Here are the commands you can use:',
            fields: [
                { name: '!ping', value: 'Check bot response time', inline: false },
                { name: '!info', value: 'Show bot information', inline: false },
                { name: '!help', value: 'Show this help message', inline: false }
            ]
        };
        message.reply({ embeds: [embed] });
    }
});

// Handle errors
client.on(Events.Error, error => {
    console.error('❌ Discord client error:', error);
});

// Handle warnings
client.on(Events.Warn, warning => {
    console.warn('⚠️ Discord client warning:', warning);
});

// Handle rate limits
client.on(Events.RateLimited, rateLimitData => {
    console.warn('🚦 Rate limited:', rateLimitData);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('🔄 Shutting down gracefully...');
    client.destroy();
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('🔄 Received SIGTERM, shutting down...');
    client.destroy();
    process.exit(0);
});

// Utility function to format uptime
function formatUptime(seconds) {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);

    const parts = [];
    if (days > 0) parts.push(`${days}d`);
    if (hours > 0) parts.push(`${hours}h`);
    if (minutes > 0) parts.push(`${minutes}m`);
    parts.push(`${secs}s`);

    return parts.join(' ');
}

// Log in to Discord
if (!process.env.DISCORD_TOKEN) {
    console.error('❌ Error: DISCORD_TOKEN not found in environment variables');
    console.error('   Please create a .env file with your bot token');
    process.exit(1);
}

client.login(process.env.DISCORD_TOKEN);