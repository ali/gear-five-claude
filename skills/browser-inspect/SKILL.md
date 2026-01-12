---
name: browser-inspect
description: "Inspect web pages for privacy, fingerprinting, and content blocker behavior. Use when user asks to 'check this site', 'inspect page', 'analyze trackers', 'test content blocker', or 'debug browser'."
allowed-tools: Read, Bash, mcp__puppeteer__*
context: fork
agent: browser-devtools
---

# Browser Inspection

## Tool Detection
First, check which tools are available:
```bash
./scripts/check-tools.sh
```

## Preferred: agent-browser CLI
See [AGENT-BROWSER.md](AGENT-BROWSER.md) for refs-based inspection.

## Fallback: Puppeteer MCP
See [PUPPETEER.md](PUPPETEER.md) if MCP is configured.
