# arXiv API Reference

## Fetching Papers

### Via trafilatura (preferred)
```bash
# Abstract page → clean markdown
trafilatura -u "https://arxiv.org/abs/2512.12345" --markdown --with-metadata

# PDF page (extracts text)
trafilatura -u "https://arxiv.org/pdf/2512.12345" --markdown
```

### Via arXiv API
```bash
# Get metadata as Atom XML
curl "http://export.arxiv.org/api/query?id_list=2512.12345"

# Search by author
curl "http://export.arxiv.org/api/query?search_query=au:lastname&max_results=10"

# Search by title
curl "http://export.arxiv.org/api/query?search_query=ti:keyword&max_results=10"
```

## Paper ID Formats
- New format: `YYMM.NNNNN` (e.g., `2512.12345`)
- Old format: `category/YYMMNNN` (e.g., `cs.CR/0601001`)

## Metadata Fields
From the Atom feed:
- `<title>` - Paper title
- `<author>` - Author names
- `<summary>` - Abstract
- `<arxiv:primary_category>` - Primary category
- `<published>` - Submission date
- `<updated>` - Last revision date
- `<arxiv:doi>` - DOI if published

## Categories (CS/Security)
- `cs.CR` - Cryptography and Security
- `cs.NI` - Networking and Internet Architecture
- `cs.LG` - Machine Learning
- `cs.AI` - Artificial Intelligence
- `cs.HC` - Human-Computer Interaction

## Rate Limits
- arXiv API: max 1 request per 3 seconds
- Use `--timeout 30` with trafilatura for large papers
