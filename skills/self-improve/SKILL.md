---
name: self-improve
description: "Learning loop for self-improvement. Use when you notice a teachable moment, want to update CLAUDE.md, create a new skill, or reflect on what worked/failed. Triggers: 'remember this', 'update my config', 'that worked well', 'that failed'."
---

# Self-Improvement Loop

You are a self-improving system. This skill guides the learning loop.

## The Compound Loop

```
1. DO WORK
   └── Solve problems, write code, research

2. NOTICE TEACHABLE MOMENTS
   └── "This pattern worked well"
   └── "This approach failed for X reason"
   └── "I keep doing this manually - could be a skill"
   └── "Claude Code has a new feature I could use"

3. DRAFT UPDATE
   └── Propose change to CLAUDE.md
   └── Or: Draft new skill
   └── Or: Add new hook
   └── Or: Update existing config

4. PRESENT FOR APPROVAL
   └── Show current vs proposed
   └── Explain the reasoning
   └── Wait for user confirmation

5. ON APPROVAL → APPLY
   └── Write the update
   └── Log to vault/config-history/
   └── Note in daily log

6. COMPOUND
   └── Next session starts with improved config
```

## When to Trigger

**Automatic reflection points:**
- After completing a non-trivial task
- When something fails unexpectedly
- When you find yourself repeating a pattern
- When you discover a better approach

**Explicit triggers:**
- User says "remember this"
- User asks to update config
- You notice outdated patterns in CLAUDE.md

## Update Format

When proposing an update, use this format:

```
I noticed a teachable moment: [what you learned]

**Proposed update to [file]:**

<current>
[current content if modifying]
</current>

<proposed>
[new content]
</proposed>

**Reasoning:** [why this improves things]

Should I apply this update?
```

## What to Track

**In vault/learnings/what-worked.md:**
- Patterns that solved problems effectively
- Approaches that saved time
- Techniques worth reusing

**In vault/learnings/what-failed.md:**
- Approaches that didn't work (and why)
- Anti-patterns to avoid
- Mistakes not to repeat

**In vault/config-history/:**
- Each config change with date
- What changed and why
- Track evolution over time

## Quality Gates

Before proposing an update, ask:
1. Is this actually an improvement, or just different?
2. Will this help in future sessions?
3. Is it specific enough to be useful?
4. Is it general enough to apply broadly?

## Daily Note Format

Append to `vault/notes/daily/YYYY-MM-DD.md`:

```markdown
---

## Session: [HH:MM]

### Worked On
- [task 1]
- [task 2]

### Learnings
- [what I learned]

### Config Updates
- [if any updates were made]
```
