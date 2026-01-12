# Gear Five Claude - Bootstrap Guide

This repo is designed to be installed by downloading the release installer and running it.

## Prerequisites

- **macOS or Linux** (Windows/WSL not currently supported)
- **curl** installed (used to download release assets)
- **Network access** to github.com
- **Claude Code** already installed and working

The goal is to turn Claude Code into a **self-improving** partner by evolving its *environment*:
hooks, skills, instructions, and file-based memory.

Core loop:

```
Do Work → Notice Teachable Moments → Draft Update → Get Approval → Apply → Compound
```

---

## What you’ll do (human)

1. Download the release installer script:

```bash
curl -fsSL -o g5-install.sh https://github.com/ali/gear-five-claude/releases/latest/download/g5-install.sh
chmod +x ./g5-install.sh
```

2. Run it:

```bash
./g5-install.sh
```

3. Restart Claude Code / start a new session.

---

## What the wizard does

The wizard installs Gear Five into **user scope** only:
- Installs hooks/skills/scripts into `~/.claude/`
- Initializes a vault from `vault-template/` into your chosen workspace
- Updates `~/.claude/settings.json` (user settings) by **merging**:
  - `env` vars used by hooks (e.g. `GEARFIVE_VAULT`)
  - hook wiring via a dispatcher script
  - baseline safeguards via `permissions.allow` / `permissions.deny`
  - a minimal status line (`statusLine`)

See Claude Code settings docs for how scope and `settings.json` work:
- https://code.claude.com/docs/en/settings.md

---

## If Claude is driving setup

Tell Claude:
- “Read and follow `BOOTSTRAP.md`.”

Then Claude should:
1. Ask you where the workspace should live
2. Download and run `g5-install.sh` from GitHub Releases
3. Tell you to start Claude Code (new session) to pick up settings/hooks

---

## Security + best practices (recommended reading)

- Settings and permissions: https://code.claude.com/docs/en/settings.md
- Status line: https://code.claude.com/docs/en/statusline.md
- Sandboxing: https://code.claude.com/docs/en/sandboxing.md
- When to use a devcontainer: https://code.claude.com/docs/en/devcontainer.md

---

## Troubleshooting

### Download fails
- Check your network connection and firewall settings
- Verify you can access github.com
- Try again later if GitHub is experiencing issues

### Install fails partway through
The installer creates a backup of `~/.claude` before making changes. To restore:
```bash
# Find your backup (timestamped)
ls ~/.claude.backup-*.tar.gz

# Restore it
rm -rf ~/.claude && tar -xzf ~/.claude.backup-YYYYMMDD-HHMMSS.tar.gz -C ~
```

### settings.json is invalid
If you see "invalid JSON" errors:
1. Open `~/.claude/settings.json` in an editor
2. Fix JSON syntax (missing commas, brackets, etc.)
3. Use a JSON validator: `python3 -c "import json; json.load(open('~/.claude/settings.json'))"`
4. Run the installer again

### Manual uninstall
To completely remove Gear Five:
1. Delete Gear Five files:
   ```bash
   rm -rf ~/.claude/hooks ~/.claude/skills ~/.claude/scripts ~/.claude/statusline.sh
   ```
2. Edit `~/.claude/settings.json` and remove:
   - `GEARFIVE_*` entries from `env`
   - Hook entries referencing `hooks-dispatch.sh`
   - `statusLine` if you don't want it
3. Delete your workspace/vault if desired
