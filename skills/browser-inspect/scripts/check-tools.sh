#!/bin/bash
# Check available browser automation tools

echo "Browser Automation Tools:"
echo "========================="

# Check agent-browser
if command -v agent-browser &> /dev/null; then
    echo "✓ agent-browser: $(which agent-browser)"
else
    echo "✗ agent-browser: not installed"
    echo "  Install: npm install -g agent-browser && agent-browser install"
fi

# Check if Puppeteer MCP might be configured
if [[ -f ".mcp.json" ]]; then
    if grep -q "puppeteer" .mcp.json 2>/dev/null; then
        echo "✓ Puppeteer MCP: configured in .mcp.json"
    else
        echo "✗ Puppeteer MCP: not in .mcp.json"
    fi
else
    echo "✗ Puppeteer MCP: no .mcp.json found"
fi

echo ""
echo "Recommended: Use agent-browser for AI-optimized browser automation"
