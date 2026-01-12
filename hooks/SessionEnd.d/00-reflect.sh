#!/bin/bash
# End of session reflection prompt

VAULT="${GEARFIVE_VAULT:-${CLAUDE_VAULT:-$HOME/src/claude-workspace/vault}}"
TODAY=$(date +%Y-%m-%d)

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
