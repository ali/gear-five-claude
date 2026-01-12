#!/bin/bash
# End of session reflection prompt

VAULT="${GEARFIVE_VAULT:-${CLAUDE_VAULT:-}}"
TODAY=$(date +%Y-%m-%d)

# Exit silently if vault not configured
if [[ -z "$VAULT" ]]; then
  exit 0
fi

# Output reflection prompt
cat << EOF
---
Session ending. Reflection checklist:
- Any teachable moments worth capturing?
- Should any configs be updated?
- Handoff needed for continuity?
Daily note: $VAULT/notes/daily/$TODAY.md
---
EOF
