# Gear Five Claude

A self-improving Claude Code configuration for **Claude Code**.

Like Luffy's Gear Five awakening, this aims to transform Claude from a static tool into a dynamic, learning partner that gets increasingly effective over time — by improving its **environment** (instructions, hooks, skills, and file-based memory), not its weights.

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

1. Start a Claude Code session.
2. Tell Claude: “Read and follow `BOOTSTRAP.md`.”
3. Claude will have you download and run the release installer, then tell you to restart/start a new Claude Code session.

## What's Included

### BOOTSTRAP.md
The entry point. It describes the install wizard flow and what it changes.

### Skills
Twelve skills in `skills/`:
- **claude-expert** - Claude Code mastery (hooks, skills, subagents)
- **self-improve** - The learning loop
- **keychain-security** - Secure credential handling
- **trafilatura** - Web content extraction (read articles, docs, blogs)
- **arxiv-paper** - Fetch and read arXiv papers (forks to literature-scout agent)
- **browser-inspect** - Browser automation for privacy research (forks to browser-devtools agent)
- **measurement-analysis** - Data analysis with pandas/SQL/stats (forks to data-analyst agent)
- **browser-security** - Security patterns for extensions, fingerprinting, CSP/CORS
- **settings-maintenance** - Audit and improve Claude Code config (forks to settings-doctor agent)
- **code-review** - Orchestrates code review agents
- **session-logs** - Search past Claude Code sessions for context and patterns
- **customize** - Create personalized skills/agents based on user's needs (forks to customization-architect)

### Agents
Eight subagents in `agents/`:

**Domain Agents:**
- **literature-scout** - Academic research and paper summarization
- **data-analyst** - Elite data analyst with pandas, SQL, statistics, Tableau
- **browser-devtools** - Browser automation (agent-browser CLI, Puppeteer MCP)
- **settings-doctor** - Claude Code configuration specialist

**Code Review Agents:**
- **security-sentinel** - Security auditing (OWASP Top 10, injection vulnerabilities)
- **code-simplifier** - YAGNI enforcer, complexity reduction
- **silent-failure-hunter** - Hunts for swallowed errors and dangerous fallbacks

**Meta Agent:**
- **customization-architect** - Designs personalized skills/agents based on user discovery

### Wizard + Installer
The Bun-based installer lives in `src/g5.ts`. It:
- Installs hooks/skills/scripts into `~/.claude/`
- Initializes your vault from `vault-template/`
- Updates **user-scoped** Claude Code settings (`~/.claude/settings.json`) with hooks, env, safeguards, and an optional status line

### Customization Command
After installation, run `g5 customize` to generate personalized skills and agents:
```bash
g5 customize
```
This guides Claude through a discovery conversation about your background, projects, and workflows, then creates custom skills and agents tailored to your specific needs.

### Optional: single-file executable
If you don’t want the runtime dependency on `bun`, you can compile `g5` into a standalone binary:

- Build docs: https://bun.sh/docs/bundler/executables

```bash
./scripts/build-g5.sh
./dist/g5 wizard
```

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
│   ├── trafilatura/
│   ├── arxiv-paper/
│   ├── browser-inspect/
│   ├── measurement-analysis/
│   ├── browser-security/
│   ├── settings-maintenance/
│   ├── code-review/
│   ├── session-logs/
│   └── customize/
├── agents/
│   ├── literature-scout.md
│   ├── data-analyst.md
│   ├── browser-devtools.md
│   ├── settings-doctor.md
│   ├── security-sentinel.md
│   ├── code-simplifier.md
│   ├── silent-failure-hunter.md
│   └── customization-architect.md
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
- [claude-code-changelog](https://github.com/marckrenn/claude-code-changelog)
- [Claude Code docs](https://code.claude.com/docs/)

Useful references:
- [Claude Code settings](https://code.claude.com/docs/en/settings.md)
- [Status line](https://code.claude.com/docs/en/statusline.md)
- [Sandboxing](https://code.claude.com/docs/en/sandboxing.md)
- [Devcontainers](https://code.claude.com/docs/en/devcontainer.md)

When new features appear or patterns become outdated, Gear Five proposes updates.

## For Forks

If you fork this repo, users need to set `G5_REPO` before running the installer:
```bash
export G5_REPO="yourname/your-fork"
curl -fsSL -o g5-install.sh https://github.com/$G5_REPO/releases/latest/download/g5-install.sh
chmod +x ./g5-install.sh && ./g5-install.sh
```

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
