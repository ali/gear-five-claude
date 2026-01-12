#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v bun >/dev/null 2>&1; then
  echo "bun is required for tests."
  echo "Install: brew install bun"
  echo "Docs: https://bun.sh/docs/installation"
  exit 1
fi

TMP_CLAUDE="$ROOT_DIR/.tmp-test-claude"
TMP_WS="$ROOT_DIR/.tmp-test-workspace"

cleanup() {
  rm -rf "$TMP_CLAUDE" "$TMP_WS"
}
trap cleanup EXIT

rm -rf "$TMP_CLAUDE" "$TMP_WS"

echo "[test] g5.ts install (dry-run) with templates-root"
OUT="$(bun ./src/g5.ts install --dry-run --yes \
  --claude-dir "$TMP_CLAUDE" \
  --workspace "$TMP_WS" \
  --templates-root "$ROOT_DIR")"

echo "$OUT" | grep -q "Would write $TMP_CLAUDE/settings.json"
echo "$OUT" | grep -q "GEARFIVE_WORKSPACE"
echo "$OUT" | grep -q "GEARFIVE_VAULT"
echo "$OUT" | grep -q "hooks-dispatch.sh"
echo "$OUT" | grep -q "statusline.sh"

echo "[test] compiled binary (if present) can run print-config"
if [[ -x "$ROOT_DIR/dist/g5" ]]; then
  "$ROOT_DIR/dist/g5" print-config >/dev/null
else
  echo "  (skipped: dist/g5 not built yet; run: ./scripts/build-g5.sh)"
fi

echo "[ok] tests passed"

