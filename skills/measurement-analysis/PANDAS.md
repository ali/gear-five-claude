# Pandas Patterns for Web Measurement

## Loading Data

```python
import pandas as pd

# CSV (most common)
df = pd.read_csv("data.csv", parse_dates=["timestamp"])

# Large files - use chunks
chunks = pd.read_csv("big.csv", chunksize=100000)
df = pd.concat(chunks)

# JSON lines (common for logs)
df = pd.read_json("data.jsonl", lines=True)

# Parquet (fast for large datasets)
df = pd.read_parquet("data.parquet")
```

## Common Transformations

### Time Series
```python
# Resample to hourly
df.set_index("timestamp").resample("1H").count()

# Rolling average
df["requests_rolling"] = df["requests"].rolling(window=24).mean()

# Time-based grouping
df.groupby(df["timestamp"].dt.date).size()
```

### Groupby Aggregations
```python
# Multiple aggregations
df.groupby("domain").agg({
    "requests": ["count", "sum"],
    "bytes": ["mean", "std"],
    "latency_ms": ["median", "max"]
})

# With named columns
df.groupby("domain").agg(
    request_count=("requests", "count"),
    avg_bytes=("bytes", "mean"),
    p95_latency=("latency_ms", lambda x: x.quantile(0.95))
)
```

### Filtering
```python
# Boolean indexing
trackers = df[df["is_tracker"] == True]

# Query syntax (cleaner for complex conditions)
df.query("status_code >= 400 and latency_ms > 1000")

# isin for multiple values
df[df["domain"].isin(["google.com", "facebook.com"])]
```

## Polars (Faster Alternative)

```python
import polars as pl

# Load
df = pl.read_csv("data.csv")

# Lazy evaluation (faster for large datasets)
lf = pl.scan_csv("big.csv")
result = lf.filter(pl.col("status") == 200).collect()

# Group by
df.group_by("domain").agg([
    pl.count(),
    pl.col("latency_ms").mean().alias("avg_latency")
])
```

## Memory Optimization

```python
# Downcast numeric types
df["status"] = pd.to_numeric(df["status"], downcast="integer")

# Categories for repeated strings
df["domain"] = df["domain"].astype("category")

# Check memory usage
df.info(memory_usage="deep")
```

## Export for Papers

```python
# LaTeX table
df.to_latex("table.tex", index=False, float_format="%.2f")

# CSV for supplementary
df.to_csv("results.csv", index=False)
```
