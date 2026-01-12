#!/bin/bash
# Generic hooks.d dispatcher for Claude Code
# Usage: hooks-dispatch.sh <hook-name> [extra-args...]
#
# Executes all executable scripts in ~/.claude/hooks/<hook-name>.d/
# Scripts are run in alphabetical order (use 00-name.sh, 10-name.sh for ordering)

HOOK_NAME="$1"
shift
HOOKS_DIR="$HOME/.claude/hooks/${HOOK_NAME}.d"

if [[ ! -d "$HOOKS_DIR" ]]; then
  exit 0
fi

# Run each executable script in order
for script in "$HOOKS_DIR"/*; do
  if [[ -f "$script" ]] && [[ -x "$script" ]]; then
    "$script" "$@"
  fi
done

exit 0
