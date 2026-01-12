# Statistical Testing for Web Measurement

## Choosing the Right Test

| Comparison | Data Type | Test |
|------------|-----------|------|
| Two groups, continuous | Normal | t-test |
| Two groups, continuous | Non-normal | Mann-Whitney U |
| Two groups, categorical | - | Chi-squared |
| Paired samples | Continuous | Wilcoxon signed-rank |
| Multiple groups | Continuous | ANOVA / Kruskal-Wallis |
| Correlation | Continuous | Pearson / Spearman |
| Distribution comparison | Continuous | Kolmogorov-Smirnov |

## Implementation

### Two-Sample Comparisons
```python
from scipy import stats

# t-test (assumes normality)
stat, p = stats.ttest_ind(group1, group2)

# Mann-Whitney U (non-parametric)
stat, p = stats.mannwhitneyu(group1, group2, alternative='two-sided')

# Effect size (Cohen's d)
def cohens_d(g1, g2):
    n1, n2 = len(g1), len(g2)
    var1, var2 = g1.var(), g2.var()
    pooled_std = np.sqrt(((n1-1)*var1 + (n2-1)*var2) / (n1+n2-2))
    return (g1.mean() - g2.mean()) / pooled_std
```

### Categorical Data
```python
# Chi-squared test
contingency = pd.crosstab(df['group'], df['outcome'])
chi2, p, dof, expected = stats.chi2_contingency(contingency)

# Fisher's exact (small samples)
odds_ratio, p = stats.fisher_exact([[a, b], [c, d]])
```

### Distribution Comparison
```python
# Kolmogorov-Smirnov test
stat, p = stats.ks_2samp(dist1, dist2)

# Check normality
stat, p = stats.shapiro(data)  # Shapiro-Wilk
stat, p = stats.normaltest(data)  # D'Agostino-Pearson
```

## Multiple Comparisons

```python
from statsmodels.stats.multitest import multipletests

# Bonferroni correction
rejected, p_adjusted, _, _ = multipletests(p_values, method='bonferroni')

# Benjamini-Hochberg (FDR)
rejected, p_adjusted, _, _ = multipletests(p_values, method='fdr_bh')
```

## Confidence Intervals

```python
import numpy as np
from scipy import stats

def bootstrap_ci(data, stat_func=np.mean, n_boot=10000, ci=0.95):
    """Bootstrap confidence interval."""
    boot_stats = [stat_func(np.random.choice(data, len(data), replace=True))
                  for _ in range(n_boot)]
    alpha = (1 - ci) / 2
    return np.percentile(boot_stats, [alpha*100, (1-alpha)*100])

# Usage
lower, upper = bootstrap_ci(latencies, stat_func=np.median)
```

## Power Analysis

```python
from statsmodels.stats.power import TTestIndPower

analysis = TTestIndPower()

# How many samples needed?
n = analysis.solve_power(effect_size=0.5, alpha=0.05, power=0.8)

# What power do we have?
power = analysis.solve_power(effect_size=0.5, alpha=0.05, nobs1=100)
```

## Reporting Guidelines

**Always report:**
1. Test statistic and p-value
2. Effect size (Cohen's d, odds ratio, etc.)
3. Confidence intervals
4. Sample sizes per group

**Avoid:**
- "Significant" without effect size
- p-hacking (multiple tests without correction)
- Confusing statistical with practical significance
