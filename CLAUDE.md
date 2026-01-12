# Gear Five Claude - Meta Configuration

This is the CLAUDE.md for the Gear Five Claude repo itself. Meta, right?

Working on this repo means you're working on *how Claude improves itself*. Handle with care.

## This Repo

Gear Five Claude is a self-bootstrapping Claude Code configuration that:
1. Creates personalized CLAUDE.md files
2. Sets up hooks for learning loops
3. Installs skills for Claude Code mastery
4. Establishes vault-based memory

The goal: transform Claude from a static tool into a dynamic, self-improving partner.

## Key Files

| File | Purpose |
|------|---------|
| `BOOTSTRAP.md` | Entry point users share with Claude to self-configure |
| `skills/` | Three core skills (claude-expert, self-improve, keychain-security) |
| `hooks/` | Modular hooks in `.d/` directories |
| `vault-template/` | Obsidian vault structure template |
| `drafts/` | Architecture decisions and research |

## Context Discipline

Context is precious. Every token competes with reasoning capacity.

**Always:**
- Use references over content (paths, not file dumps)
- Dynamic discovery: grep/glob to find, read what's needed
- Keep sessions short and focused

**Never:**
- Stuff context "just in case"
- Read full files when sections suffice
- Let bloated context accumulate

## When Editing This Repo

### Adding a Skill
1. Create `skills/{name}/SKILL.md`
2. Frontmatter must have `name` and `description` with trigger phrases
3. Update README.md skills list
4. Update BOOTSTRAP.md if it should be installed by default

### Adding a Hook
1. Create script in `hooks/{EventName}.d/{NN}-{name}.sh`
2. Make executable
3. Update hooks-dispatch.sh if needed
4. Document in README.md

### Changing the Bootstrap
1. Test by actually bootstrapping a fresh environment
2. Phase order matters: Gather → Structure → Configure → Initialize → Verify
3. Keep questions minimal - users abandon long setup flows

## Testing Changes

After modifications:
```bash
# Verify structure
ls -la skills/
ls -la hooks/*/

# Test hooks dispatch
./scripts/hooks-dispatch.sh SessionStart

# Grep for stale references
grep -r "context-hygiene" . --include="*.md"
```

## Philosophy Reminders

From the research that shaped this project:
- **"200k tokens is plenty"** - Short focused sessions > bloated context
- **"Agents get drunk on too many tokens"** - Context discipline matters
- **"File system as context"** - References over content
- **The compound loop** - Do Work → Notice → Draft → Approve → Apply → Compound

## Tooling

- `bun` for JS/TS (never npm/yarn/pnpm)
- `uv` for Python (never pip)
- `cargo` for Rust
