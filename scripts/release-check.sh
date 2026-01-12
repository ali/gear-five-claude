#!/bin/bash
set -euo pipefail

# Basic checks to run before tagging a release.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[check] working tree clean"
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash first." >&2
  git status --porcelain >&2
  exit 1
fi

echo "[check] expected files exist"
test -f "./release/g5-install.sh"
test -f "./scripts/build-g5.sh"
test -f "./src/g5.ts"
test -f "./BOOTSTRAP.md"

echo "[check] BOOTSTRAP points to correct repo"
grep -q "https://github.com/ali/gear-five-claude/releases/latest/download/g5-install.sh" ./BOOTSTRAP.md

echo "[check] release installer defaults to correct repo"
grep -q 'G5_REPO="${G5_REPO:-ali/gear-five-claude}"' ./release/g5-install.sh

echo "[check] CI targets pass locally"
make test

echo "[ok] release checks passed"

