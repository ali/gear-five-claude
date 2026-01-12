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
| `src/g5.ts` | Gear Five wizard/installer source (Bun CLI entrypoint) |
| `release/g5-install.sh` | Release installer script users download+run (no clone required) |
| `scripts/build-g5.sh` | Build compiled `g5-*` binaries + `g5-templates.tar.gz` |
| `scripts/test.sh` | Lightweight sanity tests (dry-run install into temp dirs) |
| `scripts/release-*.sh` | Release check/notes/tag helpers |
| `.github/workflows/` | CI + release automation |

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
1. The canonical UX is **release-installer-based**: Claude reads `BOOTSTRAP.md` → user downloads `g5-install.sh` from Releases → runs it → start/restart Claude Code
2. Keep questions minimal - users abandon long setup flows
3. If you change install behavior, update ALL of: `BOOTSTRAP.md`, `README.md`, `release/g5-install.sh`, and the release workflow (`.github/workflows/release.yml`)

## Testing Changes

After modifications:
```bash
# Verify structure
ls -la skills/
ls -la hooks/*/

# Run local sanity tests
make test

# Build compiled binaries + templates bundle (do not commit dist/)
make build

# Release preflight checks (expects clean working tree)
make release-check

# Grep for stale references
grep -r "scripts/g5.ts" . --include="*.md" --include="*.sh"
```

## Dev workflow (repo maintenance)

### Pre-commit hooks (recommended)

This repo ships repo-local git hooks under `.githooks/`.

Enable them for this repo:
```bash
make hooks-install
```

The pre-commit hook runs:
- `shellcheck` on `*.sh`
- `oxfmt` + `oxlint` on staged JS/TS (uses local binaries if installed, otherwise falls back to `bunx`)

## Release & Distribution

### What gets published (GitHub Releases)

- **Binaries**: `g5-<os>-<arch>` (built by GitHub Actions), e.g.:
  - `g5-darwin-arm64`
  - `g5-darwin-x64`
  - `g5-linux-x64`
- **Templates bundle**: `g5-templates.tar.gz` (hooks/skills/vault-template/scripts)
- **Installer**: `g5-install.sh` (downloads the right binary + templates, installs `~/.claude/bin/g5`, runs `g5 wizard`)

### How to cut a release

Prereqs:
- You are on `main`
- Working tree is clean

Commands:
```bash
make release-check
make tag-release VERSION=vX.Y.Z
```

Notes:
- Tag pushes trigger `.github/workflows/release.yml` which builds and uploads assets.
- Release notes template: `make release-notes VERSION=vX.Y.Z`

## Important invariants

- **User-scope only**: Gear Five modifies `~/.claude/settings.json` (never project scope) per Claude Code scope model.
- **Non-destructive merge**: only add/update Gear Five-owned keys; never clobber unrelated settings.
- **No hardcoded vault paths in hooks**: hooks should read `GEARFIVE_VAULT` (and optionally fall back to `CLAUDE_VAULT`).
- **Never commit build artifacts**: `dist/` is ignored.

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
