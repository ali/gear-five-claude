# Gear Five Claude - Research Synthesis

## Sources Analyzed

1. **antirez** - AI changing programming forever, "multiply yourself"
2. **Every.to** - Compound engineering: Plan → Work → Assess → Compound
3. **Continuous-Claude-v3** - 109 skills, 32 agents, 30 hooks, YAML handoffs
4. **compound-engineering-plugin** - 27 agents, 22 commands, parallel subagents
5. **RLM paper** - Recursive Language Models, context as variable
6. **Amp "200k is plenty"** - Short threads > long threads
7. **Anthropic Context Engineering** - Smallest set of high-signal tokens
8. **Cursor Dynamic Context** - Files for dynamic context discovery
9. **Manus Context Engineering** - KV-cache, file system as context
10. **Vercel Agents** - Filesystem + bash as the universal interface

## Key Insights

### The Core Problem
Claude starts fresh every session. No memory, no learning, no improvement.
"Configured" Claude follows rules. "Alive" Claude gets better over time.

### What "Self-Improving" Actually Means
Claude can't modify its weights. But it CAN modify its environment:
- CLAUDE.md (its instructions)
- Skills (its capabilities)
- Memory files (its knowledge)
- Hooks (its reflexes)

**The environment IS the learnable substrate.**

### Context Engineering Principles

1. **Smallest possible set of high-signal tokens** (Anthropic)
2. **Short threads > long threads** - "Agents get drunk on too many tokens" (Amp)
3. **Dynamic context discovery** - Let agent pull what it needs (Cursor)
4. **File system as context** - Unlimited, persistent, agent-operable (Manus)
5. **Just-in-time retrieval** - References over full content (Claude Code)
6. **Compaction before loss** - Summarize before context limit (all)
7. **Keep errors in context** - They prevent repeat mistakes (Manus)

### The Compound Loop
```
Plan → Work → Assess → Compound → (better next time)
```
The "Compound" step is where learning happens:
- Document what worked/failed
- Extract patterns
- Update CLAUDE.md
- Create skills from repeated workflows

### Hook Architecture for Learning

| Hook | Learning Opportunity |
|------|---------------------|
| SessionStart | Recall relevant learnings, load context |
| UserPromptSubmit | Track what questions lead to good outcomes |
| PostToolUse(Edit) | Track edit fate: reverted = bad, committed = good |
| PreCompact | Extract "what I learned" before memory loss |
| Stop | Evaluate session outcome, link to strategies |
| SessionEnd | Compare outcome to intent, update strategies |

### File-Based Memory (Not Database)

Why files over SQLite/PostgreSQL:
- **Portable** - Works anywhere, no setup
- **Inspectable** - Human-readable, debuggable
- **Agent-operable** - Claude can read/write/grep
- **Git-able** - Version controlled
- **Obsidian-compatible** - Rich UI for review

Structure:
```
vault/
├── notes/daily/YYYY-MM-DD.md     # Append-only session logs
├── notes/handoffs/               # Session continuity
├── learnings/                    # Extracted insights
│   ├── what-worked.md
│   ├── what-failed.md
│   └── patterns/
└── Index.md                      # Entry point
```

### The "Suggest + Confirm" Pattern
User wants: Claude proposes updates, waits for approval before writing.

This means:
- Claude drafts changes to a scratchpad
- Presents them for review
- Only writes on confirmation
- Tracks what was accepted vs rejected (more learning data!)

## Design Decisions

### 1. Self-Bootstrapping
The BOOTSTRAP.md should:
- Ask questions upfront (workspace location, identity, preferences)
- Create directory structure
- Install hooks and skills
- Generate personalized CLAUDE.md
- Set up Obsidian vault

### 2. Obsidian Vault as Memory
- Daily notes for session logs (append-only, safe for concurrent use)
- Handoff files for continuity (unique filenames, no collision)
- Learnings directory for extracted patterns
- All files minimal, context-efficient

### 3. Hooks for Learning Loops
Key hooks:
- **SessionStart**: Inject compact context (counts, not full content)
- **PreCompact**: Auto-save learnings before context loss
- **SessionEnd**: Evaluate outcome, update strategies

### 4. AskUserQuestion-First
When uncertain, ASK. Don't assume.
Track what clarifications led to good outcomes.

### 5. Context Hygiene
- Use references, not full content
- Dynamic discovery via grep/glob
- Compaction that preserves retrievability
- Never stuff context "just in case"

## Next Steps
1. Draft BOOTSTRAP.md structure
2. Design minimal hook set
3. Create Obsidian vault template
4. Write core skills (keychain, context-hygiene, self-improve)
