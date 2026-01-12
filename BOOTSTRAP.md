# Gear Five Claude - Bootstrap Guide

This repo is designed to be installed by cloning it and running a wizard.

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
