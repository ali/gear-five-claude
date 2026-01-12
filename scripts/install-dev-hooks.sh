#!/bin/bash
set -euo pipefail

# Enable repo-local git hooks from .githooks/
#
# This sets core.hooksPath for THIS repo only (local git config).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

git config core.hooksPath .githooks
chmod +x .githooks/pre-commit

echo "Enabled hooks: $(git config core.hooksPath)"
echo "Installed: .githooks/pre-commit"

