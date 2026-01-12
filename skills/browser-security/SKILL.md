---
name: browser-security
description: "Analyze browser extensions and web code for security/privacy issues. Use when user mentions 'content blocker', 'extension security', 'XSS', 'fingerprinting', 'privacy leak', or 'CSP bypass'."
allowed-tools: Read, Grep, Glob, Bash
---

# Browser Security Analysis

## Quick Checklist
1. Extension manifest permissions
2. Content script injection points
3. CSP/CORS policy gaps
4. Fingerprinting surface area

For detailed patterns, see:
- [CONTENT-BLOCKERS.md](CONTENT-BLOCKERS.md) - Bypass techniques
- [EXTENSIONS.md](EXTENSIONS.md) - Manifest analysis
- [FINGERPRINTING.md](FINGERPRINTING.md) - Detection vectors
- [CSP-CORS.md](CSP-CORS.md) - Policy analysis
