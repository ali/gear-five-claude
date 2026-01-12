# agent-browser CLI Reference

AI-optimized browser automation from Vercel Labs. Uses refs (@e1, @e2) for deterministic element targeting.

## Installation
```bash
npm install -g agent-browser && agent-browser install
```

## Core Commands

### Navigation
```bash
agent-browser open "https://example.com"
agent-browser navigate "https://example.com/page"
agent-browser back
agent-browser forward
agent-browser refresh
```

### Page Inspection
```bash
# Accessibility tree with refs (primary method)
agent-browser snapshot -i --json

# Screenshot (saves to file)
agent-browser screenshot

# Get page HTML
agent-browser html
```

### Interaction
```bash
# Click by ref
agent-browser click @e2

# Type into element
agent-browser type @e5 "search query"

# Fill form field
agent-browser fill @e3 "value"

# Select dropdown option
agent-browser select @e4 "option-value"
```

### Privacy Research
```bash
# Get all cookies
agent-browser cookies

# Get console output (errors, warnings, logs)
agent-browser console

# Network requests (if available)
agent-browser network
```

## Workflow Example
```bash
# 1. Open page
agent-browser open "https://example.com"

# 2. Get snapshot with refs
agent-browser snapshot -i --json

# 3. Find element of interest (from snapshot output)
# Output shows: @e2 [button] "Accept Cookies"

# 4. Interact with element
agent-browser click @e2

# 5. Check cookies after interaction
agent-browser cookies
```

## Key Advantages
- **Refs are stable**: @e2 always refers to same element until page changes
- **AI-optimized output**: Snapshot is formatted for LLM consumption
- **No re-querying**: Unlike selectors, refs don't need re-evaluation

## Privacy Analysis Patterns
```bash
# Check for third-party requests
agent-browser open "https://site.com"
agent-browser network | grep -v "site.com"

# Before/after content blocker
agent-browser cookies  # baseline
# enable blocker
agent-browser refresh
agent-browser cookies  # compare
```
