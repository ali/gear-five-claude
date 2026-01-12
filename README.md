# Gear Five Claude

A self-improving Claude Code expert. Like Luffy's Gear Five awakening, this transforms Claude from a static tool into a dynamic, learning partner that gets increasingly cracked at Claude Code itself.

## The Core Loop

```
Be cracked → Learn something → Update your OS → Become more cracked
```

Gear Five Claude:
1. **Masters Claude Code** - hooks, skills, subagents, commands
2. **Self-maintains** - updates configs when something improves
3. **Stays current** - tracks Claude Code changelog for new features
4. **Operates efficiently** - never wastes tokens on stale context

## Quick Start

1. Start a new Claude Code session
2. Ask Claude to read this bootstrap URL:
   ```
   Please read and follow: [BOOTSTRAP.md raw URL]
   ```
3. Answer the setup questions
4. Gear Five awakens

## What's Included

### BOOTSTRAP.md
The entry point. Claude reads this and self-configures through 5 phases:
1. **Gather** - Ask questions about workspace, identity, use case
2. **Structure** - Create directories and vault
3. **Configure** - Generate CLAUDE.md, install hooks
4. **Initialize** - Create first daily note
5. **Verify** - Test everything works

### Skills
Four core skills in `skills/`:
- **claude-expert** - Claude Code mastery (hooks, skills, subagents)
- **self-improve** - The learning loop
- **keychain-security** - Secure credential handling
- **context-hygiene** - Context window management

### Hooks
Modular hooks in `hooks/`:
- **SessionStart.d/** - Inject compact context
- **PreCompact.d/** - Save state before compaction
- **SessionEnd.d/** - Reflection prompts

### Vault Template
Obsidian vault structure in `vault-template/`:
- `notes/daily/` - Session logs (append-only)
- `notes/handoffs/` - Continuity between sessions
- `learnings/` - What worked, what failed
- `config-history/` - Track configuration evolution

## The Compound Loop

```
1. DO WORK
   └── Solve problems, write code, research

2. NOTICE TEACHABLE MOMENTS
   └── "This pattern worked well"
   └── "This approach failed for X reason"
   └── "I keep doing this manually - could be a skill"

3. DRAFT UPDATE
   └── Propose change to CLAUDE.md, skill, or hook

4. PRESENT FOR APPROVAL
   └── Show current vs proposed
   └── Wait for user confirmation

5. ON APPROVAL → APPLY
   └── Write the update
   └── Log to vault

6. COMPOUND
   └── Next session starts better
```

## Context Engineering Philosophy

From the research that informed this project:
- **"200k tokens is plenty"** - Short focused sessions > bloated context
- **"Agents get drunk on too many tokens"** - Context discipline matters
- **"File system as context"** - References over content
- **"Keep errors in context"** - They prevent repeat mistakes

Key sources:
- [Anthropic: Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Cursor: Dynamic Context Discovery](https://cursor.com/blog/dynamic-context-discovery)
- [Manus: Context Engineering Lessons](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [RLM Paper](https://arxiv.org/abs/2512.24601)

## Directory Structure After Bootstrap

```
~/.claude/
├── CLAUDE.md                 # Personalized, self-maintained
├── settings.json             # Hooks configuration
├── hooks/
│   ├── SessionStart.d/
│   ├── PreCompact.d/
│   └── SessionEnd.d/
├── skills/
│   ├── claude-expert/
│   ├── self-improve/
│   ├── keychain-security/
│   └── context-hygiene/
└── scripts/
    └── hooks-dispatch.sh

~/src/claude-workspace/       # Or wherever you chose
├── vault/
│   ├── Index.md
│   ├── notes/{daily,handoffs,projects}/
│   ├── learnings/
│   └── config-history/
└── ...
```

## Staying Current

Gear Five tracks Claude Code updates via:
- https://github.com/marckrenn/claude-code-changelog
- https://code.claude.com/docs/

When new features appear or patterns become outdated, Gear Five proposes updates.

## Future Plans

- **Semantic search** - Rust/SQLite/embeddings for vault search
- **More skills** - Based on common patterns that emerge
- **Better hooks** - As Claude Code evolves

## Credits

Inspired by and synthesizing patterns from:
- [Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3)
- [Every's Compound Engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- antirez on AI and programming
- Anthropic's context engineering research

---

*Gear Five: Not just configured, but alive.*
