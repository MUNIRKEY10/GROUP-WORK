"""
Goodness of Fit Tests
Includes: QQ plots, Calibration plots, and Kolmogorov-Smirnov test
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Generate sample data
np.random.seed(42)
sample_data = np.random.gamma(shape=5, scale=2, size=100)

# Fit gamma distribution using method of moments
m = np.mean(sample_data)
v = np.var(sample_data, ddof=1)
fitted_shape = m**2 / v
fitted_scale = v / m

print("=== Goodness of Fit Tests ===\n")
print(f"Sample size: {len(sample_data)}")
print(f"Fitted parameters: shape={fitted_shape:.4f}, scale={fitted_scale:.4f}")

# Create visualization
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# 1. QQ Plot
print("\n--- QQ Plot ---")
print("Compares sample quantiles to theoretical quantiles")

theoretical_quantiles = stats.gamma.ppf(np.linspace(0.01, 0.99, len(sample_data)),
                                        fitted_shape, scale=fitted_scale)
observed_quantiles = np.sort(sample_data)

axes[0, 0].scatter(theoretical_quantiles, observed_quantiles, alpha=0.6)
axes[0, 0].plot([theoretical_quantiles.min(), theoretical_quantiles.max()],
                [theoretical_quantiles.min(), theoretical_quantiles.max()],
                'r--', linewidth=2, label='Perfect fit')
axes[0, 0].set_xlabel('Theoretical Quantiles')
axes[0, 0].set_ylabel('Observed Quantiles')
axes[0, 0].set_title('QQ Plot')
axes[0, 0].legend()
axes[0, 0].grid(True, alpha=0.3)

# 2. Calibration Plot
print("\n--- Calibration Plot ---")
print("Shows empirical CDF of theoretical CDF values")
print("Should follow diagonal if distribution fits well")

# Transform data using fitted CDF
cdf_values = stats.gamma.cdf(sample_data, fitted_shape, scale=fitted_scale)

# Calculate empirical CDF of these values
sorted_cdf = np.sort(cdf_values)
empirical_cdf = np.arange(1, len(sorted_cdf) + 1) / len(sorted_cdf)

axes[0, 1].step(sorted_cdf, empirical_cdf, where='post', linewidth=2, label='Empirical CDF')
axes[0, 1].plot([0, 1], [0, 1], 'gray', linewidth=2, linestyle='--', label='Perfect calibration')
axes[0, 1].set_xlabel('Theoretical CDF')
axes[0, 1].set_ylabel('Empirical CDF')
axes[0, 1].set_title('Calibration Plot')
axes[0, 1].legend()
axes[0, 1].grid(True, alpha=0.3)
axes[0, 1].set_xlim([0, 1])
axes[0, 1].set_ylim([0, 1])

# 3. Kolmogorov-Smirnov Test
print("\n--- Kolmogorov-Smirnov Test (One-sample) ---")
ks_stat, ks_pval = stats.kstest(sample_data,
                                  lambda x: stats.gamma.cdf(x, fitted_shape, scale=fitted_scale))
print(f"KS statistic (D): {ks_stat:.6f}")
print(f"p-value: {ks_pval:.4f}")

if ks_pval > 0.05:
    print("Conclusion: Cannot reject H0. Data is consistent with fitted distribution.")
else:
    print("Conclusion: Reject H0. Data may not follow fitted distribution.")

# Visualize KS test
x_sorted = np.sort(sample_data)
theoretical_cdf = stats.gamma.cdf(x_sorted, fitted_shape, scale=fitted_scale)
empirical_cdf_full = np.arange(1, len(x_sorted) + 1) / len(x_sorted)

axes[1, 0].step(x_sorted, empirical_cdf_full, where='post', label='Empirical CDF', linewidth=2)
axes[1, 0].plot(x_sorted, theoretical_cdf, 'r-', label='Theoretical CDF', linewidth=2)

# Show maximum difference
idx_max = np.argmax(np.abs(empirical_cdf_full - theoretical_cdf))
axes[1, 0].vlines(x_sorted[idx_max], empirical_cdf_full[idx_max], theoretical_cdf[idx_max],
                  colors='green', linewidth=2, label=f'Max diff (D={ks_stat:.3f})')

axes[1, 0].set_xlabel('Value')
axes[1, 0].set_ylabel('Cumulative Probability')
axes[1, 0].set_title('Kolmogorov-Smirnov Test Visualization')
axes[1, 0].legend()
axes[1, 0].grid(True, alpha=0.3)

# 4. Two-sample KS Test
print("\n--- Kolmogorov-Smirnov Test (Two-sample) ---")
print("Comparing two samples from different distributions")

# Generate two samples
np.random.seed(42)
sample1 = np.random.normal(0, 1, 100)
sample2 = np.random.normal(0.5, 1, 100)

ks_2sample = stats.ks_2samp(sample1, sample2)
print(f"Sample 1: N(0, 1), n=100")
print(f"Sample 2: N(0.5, 1), n=100")
print(f"KS statistic (D): {ks_2sample.statistic:.6f}")
print(f"p-value: {ks_2sample.pvalue:.4f}")

if ks_2sample.pvalue < 0.05:
    print("Conclusion: Reject H0. Samples come from different distributions.")
else:
    print("Conclusion: Cannot reject H0. Samples may come from same distribution.")

# Visualize two-sample comparison
x1_sorted = np.sort(sample1)
x2_sorted = np.sort(sample2)
ecdf1 = np.arange(1, len(x1_sorted) + 1) / len(x1_sorted)
ecdf2 = np.arange(1, len(x2_sorted) + 1) / len(x2_sorted)

axes[1, 1].step(x1_sorted, ecdf1, where='post', label='Sample 1', linewidth=2)
axes[1, 1].step(x2_sorted, ecdf2, where='post', label='Sample 2', linewidth=2)
axes[1, 1].set_xlabel('Value')
axes[1, 1].set_ylabel('Cumulative Probability')
axes[1, 1].set_title('Two-Sample KS Test')
axes[1, 1].legend()
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/goodness_of_fit.png', dpi=150)
print("\nVisualization saved as goodness_of_fit.png")
plt.close()
