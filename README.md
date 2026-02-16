# OpenClaw Skills Library

Public collection of skills for OpenClaw AI agents.

## About OpenClaw Skills

Skills extend OpenClaw agents with specialized knowledge, workflows, and tools. They transform general-purpose agents into domain experts with procedural knowledge that no model can fully possess.

## Available Skills

### discord-bot-manager

Complete Discord bot lifecycle management - setup, deployment, monitoring, and maintenance.

**Features:**
- Automated Discord bot project creation with Discord.js
- Background process management (start/stop/status/restart)
- Production systemd service integration 
- Comprehensive logging and monitoring
- Discord API setup and deployment guides
- Full-featured bot template with commands and error handling

**Quick Start:**
```bash
# Download the packaged skill
curl -O https://github.com/smilinTux/openclaw-skills/raw/main/discord-bot-manager.skill

# Or clone the repository for source
git clone https://github.com/smilinTux/openclaw-skills.git
```

**Usage:**
```bash
# Create new bot project
./discord-bot-manager/scripts/setup-discord-bot.sh "my-bot" /path/to/directory

# Deploy and manage
./discord-bot-manager/scripts/bot-start.sh
./discord-bot-manager/scripts/bot-status.sh
```

## Contributing

Skills are welcome! Each skill should include:
- `SKILL.md` - Instructions for AI agents
- `README.md` - Human documentation  
- `scripts/` - Executable automation (optional)
- `references/` - Documentation for context loading (optional)
- `assets/` - Templates and resources (optional)

## License

Individual skills may have their own licenses. Check each skill's directory for specific licensing terms.

## Community

- **OpenClaw:** https://openclaw.ai
- **Discord:** https://discord.com/invite/clawd
- **Skills Hub:** https://clawhub.com

---

**Created by the OpenClaw community for AI agents everywhere** 🤖✨