#!/bin/bash
# Validate Claude Code settings.json

SETTINGS="${HOME}/.claude/settings.json"

if [[ ! -f "$SETTINGS" ]]; then
    echo "Error: $SETTINGS not found"
    exit 1
fi

echo "Validating: $SETTINGS"

# Try python first, then node, then jq
if command -v python3 &> /dev/null; then
    if python3 -c "import json; json.load(open('$SETTINGS'))" 2>&1; then
        echo "✓ JSON is valid (python3)"
        exit 0
    else
        echo "✗ JSON is invalid"
        exit 1
    fi
elif command -v node &> /dev/null; then
    if node -e "JSON.parse(require('fs').readFileSync('$SETTINGS'))" 2>&1; then
        echo "✓ JSON is valid (node)"
        exit 0
    else
        echo "✗ JSON is invalid"
        exit 1
    fi
elif command -v jq &> /dev/null; then
    if jq empty "$SETTINGS" 2>&1; then
        echo "✓ JSON is valid (jq)"
        exit 0
    else
        echo "✗ JSON is invalid"
        exit 1
    fi
else
    echo "Warning: No JSON validator found (need python3, node, or jq)"
    exit 2
fi
