---
name: discord-bot-manager
description: Complete Discord bot lifecycle management - setup, deployment, monitoring, and maintenance. Use when you need to create new Discord bots, deploy existing bots, set up bot infrastructure, monitor bot health, configure systemd services, or manage bot operations. Covers Discord.js setup, environment configuration, background process management, logging, and production deployment patterns.
---

# Discord Bot Manager

## Overview

This skill provides complete Discord bot lifecycle management from initial setup through production deployment and ongoing maintenance. It includes automated scripts for bot management, systemd service integration, and comprehensive monitoring tools.

## Workflow Decision Tree

**New bot project:** → Setup & Initialize → Deploy → Monitor
**Existing bot:** → Deploy → Monitor → Maintain
**Production deployment:** → Systemd Service → Monitor & Scale
**Bot issues:** → Status Check → Logs → Restart

## Setup & Initialize

### Quick Bot Setup

Use `setup-discord-bot.sh` to create a new Discord bot project:

```bash
# Create new bot project
./setup-discord-bot.sh "my-awesome-bot" /path/to/bot-directory
```

This creates:
- Complete Node.js project structure
- Discord.js dependencies installed
- Basic bot template with commands
- Environment configuration
- Management scripts copied
- Log directories prepared

### Manual Setup

For custom projects, copy the bot template from `assets/bot-template/`:
- `package.json` - Discord.js dependencies
- `bot.js` - Feature-complete bot template
- `.env.template` - Environment configuration template

## Deploy & Manage

### Background Process Management

Use the included management scripts for reliable bot operations:

```bash
# Start bot in background
./bot-start.sh

# Check status & logs
./bot-status.sh

# Restart bot
./bot-restart.sh

# Stop bot gracefully
./bot-stop.sh
```

Each script provides:
- Process ID tracking
- Timestamped logging
- Graceful shutdown handling
- Status reporting with uptime

### Production Systemd Service

For production deployments, install as a systemd service:

```bash
# Install as system service
./install-systemd-service.sh bot-name

# Manage with systemctl
sudo systemctl status bot-name
sudo systemctl restart bot-name
sudo journalctl -u bot-name -f
```

Benefits:
- Automatic restart on crash
- Boot-time startup
- System integration
- Centralized logging

## Monitor & Maintain

### Status Monitoring

The `bot-status.sh` script provides comprehensive health checks:
- Process existence verification
- Resource usage (CPU, memory)
- Uptime tracking
- Recent log output
- Management command reference

### Log Management

Logs are automatically organized by timestamp:
```
logs/
├── bot-20260216-041838.log    # Script-managed logs
├── systemd.log                # Systemd stdout
└── systemd-error.log          # Systemd stderr
```

### Common Maintenance Tasks

**Bot not responding:**
1. Check status: `./bot-status.sh`
2. Review logs: `tail -50 logs/bot-*.log`
3. Restart: `./bot-restart.sh`

**Memory issues:**
1. Monitor with `htop -p $(pgrep -f "node.*bot")`
2. Check for memory leaks in bot code
3. Consider restart scheduling

**Permission errors:**
1. Verify Discord bot permissions in server
2. Check required intents in Discord Developer Portal
3. Review bot role hierarchy

## Reference Documentation

### Discord API Setup
See `references/discord-api-setup.md` for:
- Creating Discord applications
- Bot token configuration
- Required intents setup
- Permission configuration
- Common setup issues

### Deployment Patterns
See `references/deployment-patterns.md` for:
- Manual vs systemd vs PM2 vs Docker
- Production considerations
- High availability setup
- Monitoring strategies
- Resource optimization

## Resources

### scripts/
- `setup-discord-bot.sh` - Complete project initialization
- `bot-start.sh` - Background process startup
- `bot-stop.sh` - Graceful shutdown
- `bot-status.sh` - Health check & monitoring
- `bot-restart.sh` - Service restart
- `install-systemd-service.sh` - System service installation

### references/
- `discord-api-setup.md` - Discord Developer Portal guide
- `deployment-patterns.md` - Production deployment strategies

### assets/bot-template/
- `package.json` - Discord.js project dependencies
- `bot.js` - Full-featured bot template with commands
- `.env.template` - Environment configuration template
