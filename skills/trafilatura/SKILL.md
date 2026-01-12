---
name: trafilatura
description: "Extract clean article text from websites using trafilatura. Use when you need to read web pages, articles, blog posts, or documentation. Better than WebFetch for article content. Triggers: 'read this URL', 'fetch article', 'extract text from', 'what does this page say'."
---

# Trafilatura - Web Content Extraction

Extract clean, readable text from web pages. Use this instead of WebFetch when you need the actual article content (not a summary).

## Installation

```bash
uv tool install trafilatura
```

## Basic Usage

**Extract article as markdown:**
```bash
trafilatura -u "https://example.com/article" --markdown
```

**Extract as plain text:**
```bash
trafilatura -u "https://example.com/article"
```

**With metadata (title, author, date):**
```bash
trafilatura -u "https://example.com/article" --markdown --with-metadata
```

## When to Use

| Scenario | Tool |
|----------|------|
| Read an article/blog post | trafilatura |
| Get verbatim page content | trafilatura |
| Quick summary of a page | WebFetch |
| API docs / technical pages | trafilatura |
| News articles | trafilatura |
| Pages behind auth | Neither (need browser) |

## Common Patterns

**Read and analyze an article:**
```bash
trafilatura -u "https://blog.example.com/post" --markdown
```
Then discuss the content with the user.

**Research a topic across multiple URLs:**
```bash
# Run for each URL, compare findings
trafilatura -u "https://site1.com/article" --markdown
trafilatura -u "https://site2.com/article" --markdown
```

**Extract academic paper info:**
```bash
trafilatura -u "https://arxiv.org/abs/2512.12345" --markdown --with-metadata
```

## Options Reference

| Flag | Purpose |
|------|---------|
| `-u URL` | URL to fetch |
| `--markdown` | Output as markdown (recommended) |
| `--with-metadata` | Include title, author, date |
| `--no-comments` | Exclude comment sections |
| `--no-tables` | Exclude tables |
| `-o FILE` | Write to file instead of stdout |

## Troubleshooting

**Empty output:** Page may be JS-rendered (trafilatura can't handle SPAs)
**Timeout:** Large pages may need `--timeout 60`
**Encoding issues:** Add `--encoding utf-8`

## vs WebFetch

- **trafilatura**: Gets full article text, better for reading/analysis
- **WebFetch**: Gets AI summary, better for quick lookups
- **yomu skill**: Similar to trafilatura but with different extraction engine

Use trafilatura when you need the actual content, not a summary.
