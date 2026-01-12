---
name: settings-maintenance
description: "Audit and improve Claude Code configuration. Use when user asks to 'check settings', 'audit config', 'fix settings', 'update claude config', or mentions settings.json issues."
allowed-tools: Read, Edit, Write, Bash, Glob, Grep, WebFetch
context: fork
agent: settings-doctor
model: opus
---

# Settings Maintenance

## Quick Audit
1. Validate JSON: `./scripts/validate-json.sh`
2. Backup first: `./scripts/backup-settings.sh`
3. Check against [CHECKLIST.md](CHECKLIST.md)

## Changelog Tracking
See [CHANGELOG.md](CHANGELOG.md) for Claude Code updates to adopt.
