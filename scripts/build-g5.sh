#!/bin/bash
set -euo pipefail

# Build a single-file native executable for g5 using Bun.
#
# Docs: https://bun.sh/docs/bundler/executables
#
# Output: dist/g5 (default)
# Also builds: dist/g5-templates.tar.gz
#
# Examples:
#   ./scripts/build-g5.sh
#   TARGET=bun-linux-x64 ./scripts/build-g5.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v bun >/dev/null 2>&1; then
  echo "bun is required to build the g5 executable."
  echo ""
  echo "Install via Homebrew:"
  echo "  brew install bun"
  echo ""
  echo "Install docs:"
  echo "  https://bun.sh/docs/installation"
  exit 1
fi

OUT_DIR="${OUT_DIR:-$ROOT_DIR/dist}"
OUT_FILE="${OUT_FILE:-$OUT_DIR/g5}"
TARGET="${TARGET:-}"

mkdir -p "$OUT_DIR"

ARGS=(build --compile "$ROOT_DIR/scripts/g5.ts" --outfile "$OUT_FILE" --minify)
if [[ -n "$TARGET" ]]; then
  ARGS+=(--target "$TARGET")
fi

bun "${ARGS[@]}"
chmod +x "$OUT_FILE"

TAR_OUT="${OUT_DIR}/g5-templates.tar.gz"
tar -czf "$TAR_OUT" \
  -C "$ROOT_DIR" \
  hooks \
  skills \
  vault-template \
  scripts/hooks-dispatch.sh \
  scripts/statusline.sh

echo "Built: $OUT_FILE"
echo "Built: $TAR_OUT"

