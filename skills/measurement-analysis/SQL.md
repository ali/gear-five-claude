# SQL Patterns for Web Measurement

## DuckDB (Local Analytics)

```python
import duckdb

# Query CSV directly (no loading!)
duckdb.sql("SELECT domain, COUNT(*) FROM 'requests.csv' GROUP BY domain")

# Query Parquet
duckdb.sql("SELECT * FROM 'data/*.parquet' WHERE status >= 400")

# Connect pandas
import pandas as pd
df = pd.read_csv("data.csv")
duckdb.sql("SELECT domain, AVG(latency) FROM df GROUP BY domain")
```

## Common Patterns

### Traffic Analysis
```sql
-- Requests per domain
SELECT
    domain,
    COUNT(*) as requests,
    SUM(bytes) as total_bytes,
    AVG(latency_ms) as avg_latency
FROM requests
GROUP BY domain
ORDER BY requests DESC
LIMIT 100;

-- Hourly traffic
SELECT
    DATE_TRUNC('hour', timestamp) as hour,
    COUNT(*) as requests
FROM requests
GROUP BY 1
ORDER BY 1;
```

### Third-Party Analysis
```sql
-- Third-party requests per page
WITH first_party AS (
    SELECT DISTINCT page_url,
           REGEXP_EXTRACT(page_url, 'https?://([^/]+)', 1) as page_domain
    FROM requests
)
SELECT
    fp.page_domain,
    r.domain as third_party,
    COUNT(*) as requests
FROM requests r
JOIN first_party fp ON r.page_url = fp.page_url
WHERE r.domain != fp.page_domain
GROUP BY 1, 2;

-- Cookie syncing detection
SELECT
    r1.domain as sender,
    r2.domain as receiver,
    COUNT(*) as sync_count
FROM requests r1
JOIN requests r2 ON r1.cookie_id = r2.cookie_id
WHERE r1.domain != r2.domain
GROUP BY 1, 2
HAVING sync_count > 10;
```

### Percentiles
```sql
-- Latency percentiles
SELECT
    domain,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY latency_ms) as p50,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY latency_ms) as p95,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY latency_ms) as p99
FROM requests
GROUP BY domain;
```

### Window Functions
```sql
-- Running totals
SELECT
    timestamp,
    requests,
    SUM(requests) OVER (ORDER BY timestamp) as cumulative
FROM hourly_stats;

-- Rank by traffic
SELECT
    domain,
    requests,
    RANK() OVER (ORDER BY requests DESC) as traffic_rank
FROM domain_stats;
```

## BigQuery Patterns

```sql
-- Efficient date partitioning
SELECT *
FROM `project.dataset.requests`
WHERE DATE(timestamp) BETWEEN '2024-01-01' AND '2024-01-31';

-- UNNEST for arrays
SELECT
    page_url,
    header.name,
    header.value
FROM requests, UNNEST(response_headers) as header
WHERE header.name = 'Set-Cookie';
```
