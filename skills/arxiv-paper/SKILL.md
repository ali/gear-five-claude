---
name: arxiv-paper
description: "Fetch and read arXiv papers. Use when user shares arxiv.org URL, asks to 'read this paper', 'summarize paper', or 'what does this paper say'."
allowed-tools: Read, Bash, WebFetch
context: fork
agent: literature-scout
---

# arXiv Paper Reader

Quick fetch:
```bash
trafilatura -u "https://arxiv.org/abs/XXXX.XXXXX" --markdown --with-metadata
```

For API details, see [REFERENCE.md](REFERENCE.md).
