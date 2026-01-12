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

