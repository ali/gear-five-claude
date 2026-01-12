---
name: session-logs
description: "Search past Claude Code sessions for context, decisions, errors, and patterns. Use when user asks to 'find that conversation', 'what did we discuss', 'search sessions', or when you need to recover context from previous work."
allowed-tools: Read, Bash, Grep, Glob
---

# Session Logs

Claude Code stores session transcripts as JSONL files in `~/.claude/projects/`.

## Directory Structure
```
~/.claude/projects/
├── {project-path-hash}/
│   ├── {session-id}.jsonl    # Full transcript
│   └── ...
└── ...
```

Each project directory is named with a hash of the project path (e.g., `-Users-ali-Developer-myproject`).

## Quick Search

### Find sessions for current project
```bash
# List session files for current project
ls -lt ~/.claude/projects/$(echo "$PWD" | tr '/' '-' | sed 's/^-//')/
```

### Search for keywords across all sessions
```bash
# Find conversations mentioning a topic
grep -r "authentication" ~/.claude/projects/ --include="*.jsonl" -l

# Find with context
grep -r "authentication" ~/.claude/projects/ --include="*.jsonl" -B 2 -A 2
```

### Search recent sessions only
```bash
# Find files modified in last 7 days
find ~/.claude/projects/ -name "*.jsonl" -mtime -7 -exec grep -l "keyword" {} \;
```

## JSONL Format

Each line is a JSON object representing a message:
```json
{"type": "user", "content": "...", "timestamp": "..."}
{"type": "assistant", "content": "...", "timestamp": "..."}
{"type": "tool_use", "name": "...", "input": {...}}
{"type": "tool_result", "content": "..."}
```

## Common Use Cases

### Recover lost context
```bash
# What were we working on yesterday?
find ~/.claude/projects/ -name "*.jsonl" -mtime -1 -exec tail -20 {} \;
```

### Find error patterns
```bash
# Find sessions with errors
grep -r '"error"' ~/.claude/projects/ --include="*.jsonl" -l
```

### Find tool usage
```bash
# Find when a specific tool was used
grep -r '"name":"Bash"' ~/.claude/projects/ --include="*.jsonl"
```

## Permissions

Gear Five gives Claude read/write access to `~/.claude/`, enabling:
- Reading past session logs
- Searching for context
- Analyzing patterns across sessions

For advanced analysis, use the `logreaver` skill if available.
