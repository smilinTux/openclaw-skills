# Discord Bot Deployment Patterns

## Deployment Options

### 1. Manual Script Management (Simple)

**Best for:** Development, small personal bots

```bash
# Start bot
./bot-start.sh

# Check status  
./bot-status.sh

# Stop bot
./bot-stop.sh
```

**Pros:** Simple, direct control
**Cons:** No auto-restart, manual management

### 2. Systemd Service (Recommended)

**Best for:** Production bots, VPS/dedicated servers

```bash
# Install as service
./install-systemd-service.sh

# Manage with systemctl
sudo systemctl start my-bot
sudo systemctl status my-bot
sudo journalctl -u my-bot -f
```

**Pros:** Auto-restart, boot startup, system integration
**Cons:** Requires sudo, Linux-only

### 3. PM2 Process Manager

**Best for:** Node.js focused environments

```bash
# Install PM2 globally
npm install -g pm2

# Start with PM2
pm2 start bot.js --name "my-bot"
pm2 monit
pm2 startup  # Enable boot startup
```

**Pros:** Node.js native, monitoring dashboard, cluster mode
**Cons:** Additional dependency

### 4. Docker Containers

**Best for:** Microservices, cloud deployments

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

**Pros:** Isolated environment, portable, scalable
**Cons:** Container complexity, resource overhead

## Production Considerations

### Logging Strategy

```javascript
// Use structured logging
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/combined.log' }),
        new winston.transports.Console({ format: winston.format.simple() })
    ],
});
```

### Error Handling

```javascript
// Graceful shutdown
process.on('SIGINT', () => {
    console.log('🔄 Shutting down gracefully...');
    client.destroy();
    process.exit(0);
});

// Uncaught exceptions
process.on('uncaughtException', (error) => {
    console.error('💥 Uncaught Exception:', error);
    // Don't exit immediately in production
    client.destroy();
    process.exit(1);
});
```

### Resource Monitoring

```bash
# Check bot resources
ps aux | grep "node.*bot"
htop -p $(pgrep -f "node.*bot")

# Monitor logs
tail -f logs/bot-*.log
journalctl -u my-bot -f --since "1 hour ago"
```

## High Availability Setup

### Multi-Server Deployment

```yaml
# docker-compose.yml for HA
version: '3.8'
services:
  bot-primary:
    image: my-bot:latest
    environment:
      - INSTANCE_ID=primary
      - REDIS_URL=redis://redis:6379
  
  bot-fallback:
    image: my-bot:latest  
    environment:
      - INSTANCE_ID=fallback
      - REDIS_URL=redis://redis:6379
      - STARTUP_DELAY=30000
    depends_on:
      - bot-primary

  redis:
    image: redis:alpine
    volumes:
      - redis-data:/data
```

### Health Checks

```javascript
// Simple HTTP health endpoint
const express = require('express');
const app = express();

app.get('/health', (req, res) => {
    const isReady = client.readyAt !== null;
    res.status(isReady ? 200 : 503).json({
        status: isReady ? 'ok' : 'not ready',
        uptime: process.uptime(),
        guilds: client.guilds.cache.size
    });
});

app.listen(3000, () => {
    console.log('Health check server on port 3000');
});
```

## Monitoring & Alerts

### Simple Monitoring Script

```bash
#!/bin/bash
# monitor-bot.sh

BOT_NAME="my-bot"
WEBHOOK_URL="https://hooks.slack.com/your/webhook"

if ! systemctl is-active --quiet "$BOT_NAME"; then
    MESSAGE="🚨 Bot $BOT_NAME is down!"
    curl -X POST -H 'Content-type: application/json' \
         --data "{\"text\":\"$MESSAGE\"}" \
         "$WEBHOOK_URL"
    
    # Try to restart
    systemctl restart "$BOT_NAME"
fi
```

### Cron Job Monitoring

```bash
# Add to crontab (crontab -e)
*/5 * * * * /path/to/monitor-bot.sh
```

This runs the monitor script every 5 minutes to check bot health.