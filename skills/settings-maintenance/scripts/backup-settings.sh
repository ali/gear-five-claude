#!/bin/bash
# Backup Claude Code settings.json

SETTINGS="${HOME}/.claude/settings.json"
BACKUP_DIR="${HOME}/.claude/backups"

if [[ ! -f "$SETTINGS" ]]; then
    echo "Error: $SETTINGS not found"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/settings.json.${TIMESTAMP}"

cp "$SETTINGS" "$BACKUP_FILE"

if [[ -f "$BACKUP_FILE" ]]; then
    echo "✓ Backup created: $BACKUP_FILE"

    # Show recent backups
    echo ""
    echo "Recent backups:"
    # shellcheck disable=SC2012
    ls -lt "$BACKUP_DIR" | head -5
else
    echo "✗ Backup failed"
    exit 1
fi
