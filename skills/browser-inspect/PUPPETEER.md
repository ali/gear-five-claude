# Puppeteer MCP Reference

Fallback browser automation via Model Context Protocol.

## Prerequisites
MCP server must be configured in `.mcp.json`:
```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"]
    }
  }
}
```

## Available Tools
When Puppeteer MCP is configured, these tools are available:
- `mcp__puppeteer__navigate` - Go to URL
- `mcp__puppeteer__screenshot` - Capture page
- `mcp__puppeteer__click` - Click element
- `mcp__puppeteer__fill` - Fill form field
- `mcp__puppeteer__evaluate` - Run JavaScript

## Basic Usage

### Navigate to page
```
mcp__puppeteer__navigate(url: "https://example.com")
```

### Take screenshot
```
mcp__puppeteer__screenshot()
```

### Click element (CSS selector)
```
mcp__puppeteer__click(selector: "#accept-cookies")
```

### Fill form
```
mcp__puppeteer__fill(selector: "input[name='email']", value: "test@example.com")
```

### Run JavaScript
```
mcp__puppeteer__evaluate(script: "document.cookie")
```

## Privacy Research Patterns

### Check cookies
```
mcp__puppeteer__navigate(url: "https://example.com")
mcp__puppeteer__evaluate(script: "document.cookie")
```

### Check localStorage
```
mcp__puppeteer__evaluate(script: "JSON.stringify(localStorage)")
```

### List third-party scripts
```
mcp__puppeteer__evaluate(script: `
  [...document.scripts]
    .map(s => s.src)
    .filter(src => src && !src.includes(location.hostname))
`)
```

## Limitations
- Requires MCP server to be running
- CSS selectors can be fragile
- No built-in accessibility tree (unlike agent-browser)
- Must configure per-project
