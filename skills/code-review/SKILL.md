---
name: code-review
description: "Review code changes for quality, security, and maintainability. Use when user asks to 'review this code', 'check my changes', 'audit this PR', or after completing significant implementation work."
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review

Select the appropriate reviewer based on the code context:

| Concern | Agent |
|---------|-------|
| Security-sensitive code | `security-sentinel` |
| Complexity/over-engineering | `code-simplifier` |
| Error handling | `silent-failure-hunter` |

## Quick Security Audit
See [SECURITY.md](SECURITY.md) for manual checklist.

## Simplicity Check
See [SIMPLICITY.md](SIMPLICITY.md) for YAGNI patterns.

## Error Handling Audit
See [ERROR-HANDLING.md](ERROR-HANDLING.md) for silent failure patterns.
