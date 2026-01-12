#!/bin/bash
set -euo pipefail

# Tag and push a release. GitHub Actions will build and attach release assets on tag push.
#
# Usage:
#   ./scripts/tag-release.sh v0.1.0
#
# This script:
# - runs ./scripts/release-check.sh
# - creates an annotated tag
# - pushes the tag to origin

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 vX.Y.Z" >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

./scripts/release-check.sh

if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "Tag already exists: $VERSION" >&2
  exit 1
fi

NOTES="$(./scripts/release-notes.sh "$VERSION")"
echo "$NOTES" > /tmp/g5-release-notes.md

git tag -a "$VERSION" -m "Release $VERSION" -F /tmp/g5-release-notes.md

echo "[push] pushing tag $VERSION"
git push origin "$VERSION"

echo ""
echo "Next:"
echo "- Watch GitHub Actions release workflow build assets for $VERSION"
echo "- Draft/edit GitHub Release notes using:"
echo "  ./scripts/release-notes.sh $VERSION"

