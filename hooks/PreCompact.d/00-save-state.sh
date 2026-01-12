#!/bin/bash
# Save state before context compaction
# This is a reminder hook - actual saving is done by Claude

VAULT="${GEARFIVE_VAULT:-${CLAUDE_VAULT:-$HOME/src/claude-workspace/vault}}"
TODAY=$(date +%Y-%m-%d)
NOW=$(date +%H:%M)

# Ensure daily note exists
DAILY_NOTE="$VAULT/notes/daily/$TODAY.md"
if [[ ! -f "$DAILY_NOTE" ]]; then
  mkdir -p "$VAULT/notes/daily"
  echo "# $TODAY" > "$DAILY_NOTE"
  echo "" >> "$DAILY_NOTE"
fi

# Output reminder
cat << EOF
---
PreCompact: Context about to be compacted at $NOW
Consider saving:
- Key learnings from this session
- Current task state
- Important decisions made
Vault path: $VAULT
---
EOF
