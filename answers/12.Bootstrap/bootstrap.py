"""
Bootstrap Resampling
Nonparametric and parametric bootstrap for inference
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

print("=== Bootstrap Resampling ===\n")

# Generate sample data
np.random.seed(42)
n = 50
true_mean = 10
true_std = 3
data = np.random.normal(true_mean, true_std, n)

print(f"Sample size: {n}")
print(f"Sample mean: {np.mean(data):.4f}")
print(f"Sample std: {np.std(data, ddof=1):.4f}\n")

# Key Concept 1: Nonparametric Bootstrap
print("--- Nonparametric Bootstrap ---")
print("Resample from observed data with replacement\n")

n_bootstrap = 10000

def bootstrap_resample(data, statistic, n_bootstrap=10000):
    """
    Perform bootstrap resampling

    Parameters:
    -----------
    data : array
        Original sample
    statistic : callable
        Function to compute on each bootstrap sample
    n_bootstrap : int
        Number of bootstrap samples

    Returns:
    --------
    bootstrap_statistics : array
        Bootstrap distribution of statistic
    """
    bootstrap_stats = []
    n = len(data)

    for _ in range(n_bootstrap):
        # Resample with replacement
        bootstrap_sample = np.random.choice(data, size=n, replace=True)
        stat = statistic(bootstrap_sample)
        bootstrap_stats.append(stat)

    return np.array(bootstrap_stats)

# Bootstrap distribution of the mean
bootstrap_means = bootstrap_resample(data, np.mean, n_bootstrap)

print(f"Bootstrap mean of means: {np.mean(bootstrap_means):.4f}")
print(f"Bootstrap SE of mean: {np.std(bootstrap_means):.4f}")
print(f"Theoretical SE: {true_std/np.sqrt(n):.4f}\n")

# 95% Confidence Interval (percentile method)
ci_lower = np.percentile(bootstrap_means, 2.5)
ci_upper = np.percentile(bootstrap_means, 97.5)

print(f"95% Bootstrap CI (percentile): [{ci_lower:.4f}, {ci_upper:.4f}]")
print(f"Sample mean: {np.mean(data):.4f}\n")

# Key Concept 2: Bootstrap for other statistics
print("--- Bootstrap for Median and Std Dev ---\n")

bootstrap_medians = bootstrap_resample(data, np.median, n_bootstrap)
bootstrap_stds = bootstrap_resample(data, lambda x: np.std(x, ddof=1), n_bootstrap)

print(f"Median: {np.median(data):.4f}")
print(f"  Bootstrap SE: {np.std(bootstrap_medians):.4f}")
print(f"  95% CI: [{np.percentile(bootstrap_medians, 2.5):.4f}, "
      f"{np.percentile(bootstrap_medians, 97.5):.4f}]\n")

print(f"Std Dev: {np.std(data, ddof=1):.4f}")
print(f"  Bootstrap SE: {np.std(bootstrap_stds):.4f}")
print(f"  95% CI: [{np.percentile(bootstrap_stds, 2.5):.4f}, "
      f"{np.percentile(bootstrap_stds, 97.5):.4f}]\n")

# Key Concept 3: Parametric Bootstrap
print("--- Parametric Bootstrap ---")
print("Fit model, then sample from fitted model\n")

# Fit normal distribution
fitted_mean = np.mean(data)
fitted_std = np.std(data, ddof=1)

parametric_means = []
for _ in range(n_bootstrap):
    # Sample from fitted model
    parametric_sample = np.random.normal(fitted_mean, fitted_std, n)
    parametric_means.append(np.mean(parametric_sample))

parametric_means = np.array(parametric_means)

print(f"Parametric bootstrap mean: {np.mean(parametric_means):.4f}")
print(f"Parametric bootstrap SE: {np.std(parametric_means):.4f}")
print(f"95% CI: [{np.percentile(parametric_means, 2.5):.4f}, "
      f"{np.percentile(parametric_means, 97.5):.4f}]\n")

# Visualization
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Plot 1: Original data
axes[0, 0].hist(data, bins=15, density=True, alpha=0.7, edgecolor='black')
x_range = np.linspace(data.min(), data.max(), 100)
axes[0, 0].plot(x_range, stats.norm.pdf(x_range, fitted_mean, fitted_std),
                'r-', linewidth=2, label='Fitted Normal')
axes[0, 0].axvline(np.mean(data), color='blue', linestyle='--', linewidth=2, label='Sample mean')
axes[0, 0].set_xlabel('Value')
axes[0, 0].set_ylabel('Density')
axes[0, 0].set_title('Original Data')
axes[0, 0].legend()

# Plot 2: Bootstrap distribution of mean
axes[0, 1].hist(bootstrap_means, bins=50, density=True, alpha=0.7, edgecolor='black')
axes[0, 1].axvline(np.mean(data), color='r', linestyle='--', linewidth=2, label='Sample mean')
axes[0, 1].axvline(ci_lower, color='g', linestyle='--', linewidth=2, label='95% CI')
axes[0, 1].axvline(ci_upper, color='g', linestyle='--', linewidth=2)
axes[0, 1].set_xlabel('Mean')
axes[0, 1].set_ylabel('Density')
axes[0, 1].set_title('Bootstrap Distribution of Mean')
axes[0, 1].legend()

# Plot 3: Bootstrap distributions comparison
axes[1, 0].hist(bootstrap_medians, bins=50, density=True, alpha=0.5,
                edgecolor='black', label='Median')
axes[1, 0].hist(bootstrap_means, bins=50, density=True, alpha=0.5,
                edgecolor='black', label='Mean')
axes[1, 0].set_xlabel('Value')
axes[1, 0].set_ylabel('Density')
axes[1, 0].set_title('Bootstrap Distributions: Mean vs Median')
axes[1, 0].legend()

# Plot 4: Nonparametric vs Parametric Bootstrap
axes[1, 1].hist(bootstrap_means, bins=50, density=True, alpha=0.5,
                edgecolor='black', label='Nonparametric')
axes[1, 1].hist(parametric_means, bins=50, density=True, alpha=0.5,
                edgecolor='black', label='Parametric')
axes[1, 1].set_xlabel('Mean')
axes[1, 1].set_ylabel('Density')
axes[1, 1].set_title('Nonparametric vs Parametric Bootstrap')
axes[1, 1].legend()

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/12.Bootstrap/bootstrap.png', dpi=150)
print("Visualization saved as bootstrap.png")
plt.close()
