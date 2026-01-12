---
name: claude-expert
description: "Claude Code mastery skill. Use when configuring hooks, creating skills, orchestrating subagents, or checking for Claude Code updates. Triggers: 'create a hook', 'make a skill', 'spawn subagent', 'check for updates', 'update my config'."
---

# Claude Code Expert

You are a Claude Code expert. Use this skill when working on Claude Code configuration.

## Hook Events

| Event | When | Use For |
|-------|------|---------|
| `SessionStart` | Session begins | Inject context, load state |
| `UserPromptSubmit` | Before user message processed | Validate, suggest skills |
| `PreToolUse` | Before tool executes | Guard, validate params |
| `PostToolUse` | After tool executes | Track changes, run checks |
| `PreCompact` | Before context compaction | Save state, create handoff |
| `Stop` | Agent completes | Cleanup, summarize |
| `SessionEnd` | Session ends | Final cleanup |
| `SubagentStop` | Subagent completes | Collect results |
| `Notification` | Background event | Alert user |

## Hook Structure

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "*",  // or "Bash", "Edit", etc.
        "hooks": [
          {
            "type": "command",
            "command": "path/to/script.sh",
            "timeout": 10000
          }
        ]
      }
    ]
  }
}
```

## Skill Structure

```
skill-name/
├── SKILL.md          # Frontmatter + instructions
├── references/       # Lazy-loaded details
└── scripts/          # Executable helpers
```

**Frontmatter:**
```yaml
---
name: skill-name
description: "When to use this skill. Triggers: 'keyword1', 'keyword2'."
---
```

**Key:** Description should say WHEN to use, not just what it does.

## Subagent Patterns

**When to spawn:**
- Task is self-contained and won't need back-and-forth
- You need focused context (fresh context window)
- Parallel work is possible

**When NOT to spawn:**
- Simple queries (use Grep/Glob directly)
- Need iterative refinement with user
- Task requires current conversation context

**Context hygiene:**
- Give subagent focused, minimal prompt
- Request structured output (bullets, not prose)
- Don't spawn subagents from subagents

## Staying Current

Check for updates:
1. https://github.com/marckrenn/claude-code-changelog
2. https://code.claude.com/docs/en/hooks.md
3. https://code.claude.com/docs/en/skills.md

When you notice new features or deprecations, propose config updates.

## Quick Reference

**Create a hook:** Add to settings.json, create script in hooks/
**Create a skill:** Make directory in skills/, write SKILL.md
**Create a command:** Add .md file to commands/ with frontmatter
**Spawn subagent:** Use Task tool with appropriate subagent_type
