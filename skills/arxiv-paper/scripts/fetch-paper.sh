#!/bin/bash
# Fetch arXiv paper content

if [[ -z "$1" ]]; then
    echo "Usage: fetch-paper.sh <arxiv-id-or-url>"
    echo ""
    echo "Examples:"
    echo "  fetch-paper.sh 2512.12345"
    echo "  fetch-paper.sh https://arxiv.org/abs/2512.12345"
    exit 1
fi

INPUT="$1"

# Extract arXiv ID from URL if needed
if [[ "$INPUT" =~ arxiv\.org ]]; then
    # Extract ID from URL like https://arxiv.org/abs/2512.12345
    ARXIV_ID=$(echo "$INPUT" | grep -oE '[0-9]{4}\.[0-9]+' | head -1)
else
    ARXIV_ID="$INPUT"
fi

if [[ -z "$ARXIV_ID" ]]; then
    echo "Error: Could not extract arXiv ID from: $INPUT"
    exit 1
fi

URL="https://arxiv.org/abs/${ARXIV_ID}"

echo "Fetching: $URL"
echo "==========================================="

if command -v trafilatura &> /dev/null; then
    trafilatura -u "$URL" --markdown --with-metadata
else
    echo "Error: trafilatura not installed"
    echo "Install: uv tool install trafilatura"
    exit 1
fi
