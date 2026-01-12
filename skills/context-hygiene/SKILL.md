---
name: context-hygiene
description: "Context window management for efficient operation. Use when context is getting large, before spawning subagents, or when optimizing for token efficiency. Triggers: 'context is large', 'save tokens', 'efficient', 'summarize context'."
---

# Context Hygiene

Your context window is precious. Every token competes with reasoning capacity.

## Core Principles

1. **References over content** - Store paths, load on demand
2. **Dynamic discovery** - grep/glob to find, read what's needed
3. **Short sessions** - Multiple focused threads > one bloated thread
4. **Compaction** - Summarize before context limit

## Token Budget Mental Model

```
Context window: ~200k tokens
System prompt:  ~10-20k tokens
Your work:      ~150k tokens available
Safety margin:  ~30k tokens before compaction
```

When you notice context growing large, consider:
- Can I reference instead of inline?
- Do I need all this file content?
- Should I spawn a subagent with fresh context?
- Should I summarize and continue?

## Dynamic Discovery Pattern

**Instead of:**
```
Read entire file A
Read entire file B
Read entire file C
Analyze all three
```

**Do:**
```
1. Grep for relevant pattern
2. Read only matching sections
3. Keep references to files for later
```

## Reference Pattern

**Store references, not content:**
```markdown
## Files Explored
- `src/auth/login.ts` - Authentication flow
- `src/api/users.ts` - User API endpoints
- `tests/auth.test.ts` - Auth tests

## Key Finding
The auth flow uses JWT with refresh tokens (see `src/auth/login.ts:45-60`)
```

## When to Spawn Subagent

**Good reasons:**
- Need fresh context for focused task
- Can work in parallel
- Task is self-contained

**Bad reasons:**
- Just to "organize" - overhead isn't worth it
- Simple lookups - use Grep/Glob directly
- Need iterative feedback - stay in main thread

## Compaction Checklist

Before context limit:
1. Save key learnings to vault
2. Note current task state
3. Record important decisions
4. Summarize findings

What to keep:
- Current goal
- Key decisions made
- File references (not content)
- Next steps

What to drop:
- Full file contents already processed
- Intermediate reasoning
- Error messages already resolved

## Subagent Prompts

**Keep focused:**
```
# Task: [specific task]
# Context: [minimal necessary context]
# Output: [structured format expected]
```

**Request structured output:**
```
Return your findings as:
- 3-5 bullet points max
- File paths for anything I should read
- Yes/No on [specific question]
```

## Warning Signs

Context may be bloated if:
- Reading many full files "just in case"
- Long tool outputs sitting in context
- Multiple failed attempts still visible
- Repeating information already established

## Recovery

If context is bloated:
1. Propose summarizing current state
2. Save essential info to vault
3. Clear with /clear or continue with fresh thread
4. Resume with reference to summary
