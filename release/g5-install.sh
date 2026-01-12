#!/bin/bash
set -euo pipefail

# Gear Five release installer
#
# Downloads:
# - g5-<os>-<arch> (single-file executable)
# - g5-templates.tar.gz (hooks/skills/vault-template/scripts)
#
# Then runs: g5 wizard --templates-root <templates>
#
# Repo (override if you fork):
#   export G5_REPO="owner/gear-five-claude"
#
# This script is intended to be hosted as a GitHub Release asset and downloaded+run.

G5_REPO="${G5_REPO:-ali/gear-five-claude}"
G5_RELEASE_BASE="https://github.com/${G5_REPO}/releases/latest/download"

# Backup directory for recovery
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
BACKUP_DIR="$HOME"

backup_claude_dir() {
  if [[ -d "$CLAUDE_DIR" ]]; then
    local stamp
    stamp=$(date +%Y%m%d-%H%M%S)
    local backup_path="${BACKUP_DIR}/.claude.backup-${stamp}.tar.gz"
    echo "Creating backup of $CLAUDE_DIR..."
    if tar -czf "$backup_path" -C "$HOME" .claude 2>/dev/null; then
      echo "Backup saved: $backup_path"
      echo ""
      echo "To restore if something goes wrong:"
      echo "  rm -rf ~/.claude && tar -xzf $backup_path -C ~"
      echo ""
    else
      echo "Warning: Could not create backup (continuing anyway)"
    fi
  fi
}

validate_settings_json() {
  local settings="$CLAUDE_DIR/settings.json"
  if [[ -f "$settings" ]]; then
    # Use python/node/jq to validate JSON - try each in order
    if command -v python3 >/dev/null 2>&1; then
      if ! python3 -c "import json; json.load(open('$settings'))" 2>/dev/null; then
        echo "Error: $settings contains invalid JSON."
        echo "Please fix it before running the installer."
        exit 1
      fi
    elif command -v node >/dev/null 2>&1; then
      if ! node -e "JSON.parse(require('fs').readFileSync('$settings'))" 2>/dev/null; then
        echo "Error: $settings contains invalid JSON."
        echo "Please fix it before running the installer."
        exit 1
      fi
    elif command -v jq >/dev/null 2>&1; then
      if ! jq empty "$settings" 2>/dev/null; then
        echo "Error: $settings contains invalid JSON."
        echo "Please fix it before running the installer."
        exit 1
      fi
    fi
    # If no JSON validator available, proceed anyway (g5.ts will catch it)
  fi
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

if ! need_cmd curl; then
  echo "curl is required to install Gear Five."
  exit 1
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  darwin) OS="darwin" ;;
  linux) OS="linux" ;;
  *)
    echo "Unsupported OS: $OS"
    echo "This installer currently supports macOS and Linux."
    exit 1
    ;;
esac

case "$ARCH" in
  arm64|aarch64) ARCH="arm64" ;;
  x86_64|amd64)  ARCH="x64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

ASSET_BIN="g5-${OS}-${ARCH}"
ASSET_TPL="g5-templates.tar.gz"

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Gear Five installer"
echo "- Repo: ${G5_REPO}"
echo "- Assets: ${ASSET_BIN}, ${ASSET_TPL}"
echo ""

# Pre-flight: backup existing ~/.claude and validate settings.json
backup_claude_dir
validate_settings_json

BIN_PATH="${TMP_DIR}/${ASSET_BIN}"
TPL_PATH="${TMP_DIR}/${ASSET_TPL}"
TPL_DIR="${TMP_DIR}/templates"

echo "Downloading binary..."
curl -fsSL "${G5_RELEASE_BASE}/${ASSET_BIN}" -o "$BIN_PATH"
chmod +x "$BIN_PATH"

echo "Downloading templates..."
curl -fsSL "${G5_RELEASE_BASE}/${ASSET_TPL}" -o "$TPL_PATH"
mkdir -p "$TPL_DIR"
tar -xzf "$TPL_PATH" -C "$TPL_DIR"

# Install the binary into ~/.claude/bin (so it’s colocated with Claude Code config).
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
INSTALL_DIR="${CLAUDE_DIR}/bin"
INSTALL_PATH="${INSTALL_DIR}/g5"
mkdir -p "$INSTALL_DIR"
cp "$BIN_PATH" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo ""
echo "Installed: ${INSTALL_PATH}"
echo ""

echo "Running wizard..."
exec "$INSTALL_PATH" wizard --templates-root "$TPL_DIR"

