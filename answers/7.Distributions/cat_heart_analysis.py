"""
Cat Heart Weight Analysis
Practical example: Fitting gamma distribution to cat heart weight data
Uses method of moments and maximum likelihood estimation
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

# Load cat data (simulated since MASS cats data is R-specific)
# The actual MASS cats dataset has 144 observations of cat heart weights
# We'll create similar data based on the reported statistics
np.random.seed(42)

# Based on MASS cats data characteristics
# Mean heart weight ≈ 10.63, SD ≈ 2.54
n_cats = 144
cats_Hwt = np.random.gamma(shape=17.5, scale=0.607, size=n_cats)  # Approximates real data

print("=== Cat Heart Weight Analysis ===\n")
print(f"Sample size: {len(cats_Hwt)}")
print(f"Mean heart weight: {np.mean(cats_Hwt):.4f} g")
print(f"SD heart weight: {np.std(cats_Hwt, ddof=1):.4f} g")
print(f"Min: {np.min(cats_Hwt):.4f} g, Max: {np.max(cats_Hwt):.4f} g")

# Visualize data
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Histogram
axes[0, 0].hist(cats_Hwt, bins=15, edgecolor='black', alpha=0.7)
axes[0, 0].set_xlabel('Heart Weight (g)')
axes[0, 0].set_ylabel('Frequency')
axes[0, 0].set_title('Histogram of Cat Heart Weights')
axes[0, 0].grid(True, alpha=0.3)

# Method of Moments estimation
print("\n--- Method of Moments Estimation ---")
m = np.mean(cats_Hwt)
v = np.var(cats_Hwt, ddof=1)
mm_shape = m**2 / v
mm_scale = v / m

print(f"Shape: {mm_shape:.4f}")
print(f"Scale: {mm_scale:.4f}")
print(f"Rate: {1/mm_scale:.4f}")

# Maximum Likelihood Estimation
print("\n--- Maximum Likelihood Estimation ---")
shape_mle, loc_mle, scale_mle = stats.gamma.fit(cats_Hwt, floc=0)

print(f"Shape: {shape_mle:.4f}")
print(f"Scale: {scale_mle:.4f}")
print(f"Rate: {1/scale_mle:.4f}")

# Compare with the lesson's result
# From lesson: shape = 20.2998092, rate = 1.9095724
print("\n--- Comparison with Lesson Results ---")
print("Results may differ due to simulated data")
print("Lesson results: shape = 20.2998, rate = 1.9096")

# Overlay fitted density on histogram
x_range = np.linspace(0, np.max(cats_Hwt)+2, 200)
axes[0, 1].hist(cats_Hwt, bins=15, density=True, edgecolor='black', alpha=0.7, label='Data')
axes[0, 1].plot(x_range, stats.gamma.pdf(x_range, mm_shape, scale=mm_scale),
                'r-', linewidth=2, label='MM fit')
axes[0, 1].plot(x_range, stats.gamma.pdf(x_range, shape_mle, scale=scale_mle),
                'b-', linewidth=2, label='MLE fit')
axes[0, 1].set_xlabel('Heart Weight (g)')
axes[0, 1].set_ylabel('Density')
axes[0, 1].set_title('Fitted Gamma Distribution')
axes[0, 1].legend()
axes[0, 1].grid(True, alpha=0.3)

# QQ plot
theoretical_quantiles = np.linspace(0.01, 0.99, len(cats_Hwt))
theoretical_values = stats.gamma.ppf(theoretical_quantiles, mm_shape, scale=mm_scale)
observed_values = np.sort(cats_Hwt)

axes[1, 0].scatter(theoretical_values, observed_values, alpha=0.6)
axes[1, 0].plot([theoretical_values.min(), theoretical_values.max()],
                [theoretical_values.min(), theoretical_values.max()],
                'r--', linewidth=2)
axes[1, 0].set_xlabel('Theoretical Quantiles')
axes[1, 0].set_ylabel('Observed Quantiles')
axes[1, 0].set_title('QQ Plot (Method of Moments)')
axes[1, 0].grid(True, alpha=0.3)

# Kernel density estimation
from scipy.stats import gaussian_kde
kde = gaussian_kde(cats_Hwt)
x_kde = np.linspace(0, np.max(cats_Hwt)+2, 200)
axes[1, 1].plot(x_kde, kde(x_kde), 'k-', linewidth=2, label='Kernel Density')
axes[1, 1].plot(x_range, stats.gamma.pdf(x_range, mm_shape, scale=mm_scale),
                'r--', linewidth=2, label='Fitted Gamma')
axes[1, 1].set_xlabel('Heart Weight (g)')
axes[1, 1].set_ylabel('Density')
axes[1, 1].set_title('Kernel Density vs. Fitted Distribution')
axes[1, 1].legend()
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/cat_heart_analysis.png', dpi=150)
print("\nVisualization saved as cat_heart_analysis.png")
plt.close()

# Goodness of fit test (Kolmogorov-Smirnov)
print("\n--- Kolmogorov-Smirnov Test ---")
ks_stat, ks_pval = stats.kstest(cats_Hwt,
                                  lambda x: stats.gamma.cdf(x, mm_shape, scale=mm_scale))
print(f"KS statistic: {ks_stat:.6f}")
print(f"p-value: {ks_pval:.4f}")
if ks_pval > 0.05:
    print("Conclusion: Cannot reject H0. Data is consistent with Gamma distribution.")
else:
    print("Conclusion: Reject H0. Data may not follow Gamma distribution.")
