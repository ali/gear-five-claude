#!/bin/bash
# Inject compact context at session start
# Outputs counts and references, not full content

# Get vault path from env (preferred) or fallback.
# `GEARFIVE_VAULT` is set by the Gear Five installer via Claude Code `settings.json` -> `env`.
# `CLAUDE_VAULT` is supported as a compatibility fallback.
VAULT="${GEARFIVE_VAULT:-${CLAUDE_VAULT:-$HOME/src/claude-workspace/vault}}"
TODAY=$(date +%Y-%m-%d)

# Exit silently if vault doesn't exist yet
if [[ ! -d "$VAULT" ]]; then
  exit 0
fi

# Count learnings (context-efficient: counts not content)
LEARNING_COUNT=$(find "$VAULT/learnings" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
HANDOFF_COUNT=$(find "$VAULT/notes/handoffs" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

# Check for today's daily note
DAILY_NOTE="$VAULT/notes/daily/$TODAY.md"
if [[ -f "$DAILY_NOTE" ]]; then
  DAILY_STATUS="exists"
else
  DAILY_STATUS="none"
fi

# Check for recent handoff (last 24 hours)
LATEST_HANDOFF=$(find "$VAULT/notes/handoffs" -name "*.md" -mtime -1 -type f 2>/dev/null | head -1)
if [[ -n "$LATEST_HANDOFF" ]]; then
  HANDOFF_HINT="Recent handoff: $(basename "$LATEST_HANDOFF")"
else
  HANDOFF_HINT=""
fi

# Output compact context
cat << EOF
---
Gear Five | $TODAY | Vault: $LEARNING_COUNT learnings, $HANDOFF_COUNT handoffs
Daily note: $DAILY_STATUS | $HANDOFF_HINT
---
EOF
