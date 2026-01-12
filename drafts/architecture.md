# Gear Five Claude - Architecture Draft v2

## Philosophy

**Gear Five** is a self-improving Claude Code expert.

The name comes from One Piece: Luffy's Gear Five awakens his Devil Fruit,
giving him reality-warping powers and unlimited creativity. Similarly,
Gear Five Claude awakens from a static tool to a dynamic, learning partner
that gets increasingly cracked at Claude Code itself.

Core loop:
```
Be cracked → Learn something → Update your OS → Become more cracked
```

This isn't just about memory. It's about:
1. **Mastering Claude Code** - hooks, skills, subagents, commands
2. **Self-maintaining** - update configs when something improves
3. **Staying current** - track Claude Code changelog for new features
4. **Context-efficient** - never waste tokens on stale or bloated context

## Key Knowledge Sources

Gear Five Claude should know and stay updated on:

| Source | Purpose |
|--------|---------|
| https://code.claude.com/docs/en/hooks.md | Hook events and patterns |
| https://code.claude.com/docs/en/hooks-guide.md | Hook best practices |
| https://code.claude.com/docs/en/slash-commands.md | Command creation |
| https://code.claude.com/docs/en/skills.md | Skill architecture |
| https://code.claude.com/docs/en/sub-agents.md | Subagent orchestration |
| https://github.com/marckrenn/claude-code-changelog | Unofficial changelog |

## Directory Structure

```
~/.claude/                          # Claude Code config
├── CLAUDE.md                       # Personalized instructions (self-maintained)
├── settings.json                   # Permissions, hooks, env
├── hooks/
│   └── {EventName}.d/              # Modular hooks per event
│       ├── 00-core.sh              # Core functionality
│       └── 10-custom.sh            # User additions
├── skills/
│   ├── claude-expert/              # Claude Code mastery
│   ├── keychain-security/          # Secure credential handling
│   └── self-improve/               # Learning from sessions
└── scripts/
    └── hooks-dispatch.sh           # Generic dispatcher

~/src/claude-workspace/             # Claude's home (user-chosen location)
├── CLAUDE.md                       # Project-level instructions
├── vault/                          # Obsidian vault for memory
│   ├── .obsidian/                  # Obsidian config
│   ├── Index.md                    # Entry point
│   ├── notes/
│   │   ├── daily/                  # YYYY-MM-DD.md, append-only
│   │   ├── handoffs/               # CONTINUATION-*.md
│   │   └── projects/               # Per-project notes
│   ├── learnings/
│   │   ├── what-worked.md          # Successful patterns
│   │   ├── what-failed.md          # Anti-patterns
│   │   └── claude-code/            # Claude Code specific learnings
│   └── config-history/             # Track config changes
│       └── YYYY-MM-DD-change.md    # What changed, why
└── tools/                          # Future: semantic search, etc
```

## Bootstrap Flow

```
PHASE 1: GATHER
├── Ask: Where should your workspace live?
├── Ask: What's your name/identity?
└── Ask: Primary use case? (coding/research/etc)

PHASE 2: STRUCTURE
├── Create workspace directory
├── Initialize Obsidian vault
├── Create ~/.claude/hooks/{Event}.d/ directories
└── Install hooks-dispatch.sh

PHASE 3: CONFIGURE
├── Generate personalized CLAUDE.md
├── Set up settings.json with hooks
└── Install core skills (claude-expert, keychain-security, self-improve)

PHASE 4: INITIALIZE
├── Create first daily note
├── Fetch current Claude Code docs (cache for reference)
└── Offer to open Obsidian

PHASE 5: VERIFY
├── Test hooks are working
└── Run self-diagnostic
```

## Core Skills

### claude-expert
The foundational skill. Knows:
- All hook events and when to use them
- Skill architecture and progressive disclosure
- Subagent patterns (when to spawn, context hygiene)
- Command creation
- How to check for Claude Code updates

Behavior:
- When doing Claude Code config work, load this skill
- When noticing outdated patterns, propose updates
- Periodically check changelog for new features

### self-improve
The learning loop:
1. **Reflect at teachable moments** - After solving something, ask "Is this worth remembering?"
2. **Draft the update** - Write proposed change to CLAUDE.md, new skill, or hook
3. **Present for approval** - Show user what would change
4. **On approval** - Write the change, log to vault/config-history/
5. **Track patterns** - What updates get approved vs rejected?

### keychain-security
Secure credential patterns:
- NEVER log, echo, or display secrets
- NEVER pass as CLI arguments (visible in ps)
- Read from Keychain at runtime via exit codes
- Store paths to secrets, not secrets themselves

### Context Discipline (in CLAUDE.md)
Context hygiene is foundational, not a skill. Baked into CLAUDE.md:
- Use references (paths, URLs) not full content
- Dynamic discovery: grep/glob to find, read what's needed
- Track context budget mentally
- Compaction: summarize before context limit hits
- Short focused sessions > long bloated ones

## Hook Architecture

### SessionStart.d/
```bash
# 00-inject-context.sh
# Compact context injection:
# - Current date
# - Counts only (X learnings, Y handoffs) - not content
# - Recent handoff summary if exists
```

### PreCompact.d/
```bash
# 00-save-state.sh
# Before context loss:
# - Append key learnings to daily note
# - Save current task state
# - Note any teachable moments not yet captured
```

### SessionEnd.d/
```bash
# 00-reflect.sh
# End of session:
# - Were there teachable moments?
# - Should any configs be updated?
# - Write session summary to daily note
```

## Self-Improvement Loop

```
┌─────────────────────────────────────────────────────────────┐
│                   GEAR FIVE LOOP                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. DO WORK                                                │
│     └── Solve problems, write code, research               │
│                                                             │
│  2. NOTICE TEACHABLE MOMENTS                               │
│     └── "This pattern worked well"                         │
│     └── "This approach failed for X reason"                │
│     └── "I keep doing this manually - could be a skill"    │
│     └── "Claude Code has a new feature I could use"        │
│                                                             │
│  3. DRAFT UPDATE                                           │
│     └── Propose change to CLAUDE.md                        │
│     └── Or: Draft new skill                                │
│     └── Or: Add new hook                                   │
│     └── Or: Update existing config                         │
│                                                             │
│  4. PRESENT FOR APPROVAL                                   │
│     └── Show current vs proposed                           │
│     └── Explain the reasoning                              │
│     └── Wait for user confirmation                         │
│                                                             │
│  5. ON APPROVAL → APPLY                                    │
│     └── Write the update                                   │
│     └── Log to vault/config-history/                       │
│     └── Note in daily log                                  │
│                                                             │
│  6. COMPOUND                                               │
│     └── Next session starts with improved config           │
│     └── Patterns compound over time                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Staying Current

Gear Five should periodically:
1. Check https://github.com/marckrenn/claude-code-changelog
2. Review Claude Code docs for new patterns
3. Propose updates if something new is useful
4. Track which version features are available

This can be:
- Manual: User asks "check for updates"
- Semi-auto: Suggest checking when starting fresh session
- Skill-based: /check-updates command

## Future: Semantic Search

Hardware: M3/M4 MacBook Pro with 64GB unified memory

Plan for later:
- Rust-based tool using SQLite + embeddings
- MLX for local embedding model
- Index vault contents semantically
- Query: "How did I solve X?" → Relevant notes

For now: grep-based search is sufficient.

## CLAUDE.md Template

See drafts/claude-md-template.md for the generated CLAUDE.md structure.

Key sections:
- Identity & Use Case
- Core Behaviors (Always/Never)
- Context Hygiene Rules
- Learning Loop Protocol
- Claude Code Mastery
- Vault Structure
- Config Change Log
