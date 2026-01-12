#!/bin/bash
# Minimal Gear Five status line for Claude Code.
#
# Configured via `settings.json` -> `statusLine` (see:
# https://code.claude.com/docs/en/settings.md and https://code.claude.com/docs/en/statusline.md)

WORKSPACE="${GEARFIVE_WORKSPACE:-}"
VAULT="${GEARFIVE_VAULT:-${CLAUDE_VAULT:-}}"

LABEL="G5"
WS_HINT=""
if [[ -n "$WORKSPACE" ]]; then
  WS_HINT="$(basename "$WORKSPACE")"
fi

VAULT_STATE="no-vault"
if [[ -n "$VAULT" ]] && [[ -d "$VAULT" ]]; then
  VAULT_STATE="vault"
fi

if [[ -n "$WS_HINT" ]]; then
  echo "$LABEL:$VAULT_STATE:$WS_HINT"
else
  echo "$LABEL:$VAULT_STATE"
fi

