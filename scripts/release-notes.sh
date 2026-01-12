#!/bin/bash
set -euo pipefail

# Generate simple release notes from git history.
#
# Usage:
#   ./scripts/release-notes.sh v0.1.0
#
# Output: prints markdown to stdout

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 vX.Y.Z" >&2
  exit 2
fi

REPO="${G5_REPO:-ali/gear-five-claude}"

PREV_TAG=""
if git describe --tags --abbrev=0 >/dev/null 2>&1; then
  PREV_TAG="$(git describe --tags --abbrev=0)"
fi

DATE="$(date +%Y-%m-%d)"

echo "# ${VERSION}"
echo ""
echo "_${DATE}_"
echo ""

if [[ -n "$PREV_TAG" ]]; then
  echo "Changes since ${PREV_TAG}:"
  echo ""
  git log "${PREV_TAG}..HEAD" --pretty=format:"- %s (%h)"
  echo ""
  echo ""
  echo "Compare: https://github.com/${REPO}/compare/${PREV_TAG}...${VERSION}"
else
  echo "Initial release."
  echo ""
  git log --pretty=format:"- %s (%h)"
fi

