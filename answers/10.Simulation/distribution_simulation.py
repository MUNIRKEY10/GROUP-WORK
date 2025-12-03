"""
Distribution Simulation
Simulating random variables from various probability distributions
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

print("=== Distribution Simulation ===\n")

# Set seed for reproducibility
np.random.seed(42)

# Key Concept: Four types of distribution functions
print("--- Four Distribution Functions ---")
print("1. pdf/pmf (d): Probability density/mass function")
print("2. cdf (p): Cumulative distribution function")
print("3. quantile (q): Inverse CDF (percentile)")
print("4. random (r): Generate random samples\n")

# Example with Normal distribution
print("Example: Normal Distribution N(μ=5, σ=2)")
mu, sigma = 5, 2

x = 6
print(f"\n1. PDF at x={x}: {stats.norm.pdf(x, mu, sigma):.6f}")
print(f"2. CDF P(X ≤ {x}): {stats.norm.cdf(x, mu, sigma):.6f}")
print(f"3. 95th percentile: {stats.norm.ppf(0.95, mu, sigma):.6f}")
print(f"4. Random sample (n=5): {stats.norm.rvs(mu, sigma, size=5)}")

# Common distributions and their simulation
print("\n--- Simulating Common Distributions ---\n")

n_samples = 1000

# 1. Normal
normal_samples = np.random.normal(mu, sigma, n_samples)
print(f"1. Normal(5, 2): mean={np.mean(normal_samples):.3f}, std={np.std(normal_samples):.3f}")

# 2. Exponential
exp_samples = np.random.exponential(scale=2.0, size=n_samples)
print(f"2. Exponential(λ=0.5): mean={np.mean(exp_samples):.3f}")

# 3. Binomial
binom_samples = np.random.binomial(n=10, p=0.3, size=n_samples)
print(f"3. Binomial(n=10, p=0.3): mean={np.mean(binom_samples):.3f}")

# 4. Poisson
poisson_samples = np.random.poisson(lam=4.5, size=n_samples)
print(f"4. Poisson(λ=4.5): mean={np.mean(poisson_samples):.3f}")

# 5. Uniform
uniform_samples = np.random.uniform(0, 1, n_samples)
print(f"5. Uniform(0, 1): mean={np.mean(uniform_samples):.3f}")

# Visualization
fig, axes = plt.subplots(2, 3, figsize=(15, 10))

# Plot 1: Normal
axes[0, 0].hist(normal_samples, bins=30, density=True, alpha=0.7, edgecolor='black')
x_range = np.linspace(normal_samples.min(), normal_samples.max(), 100)
axes[0, 0].plot(x_range, stats.norm.pdf(x_range, mu, sigma), 'r-', linewidth=2)
axes[0, 0].set_title('Normal(5, 2)')
axes[0, 0].set_xlabel('Value')
axes[0, 0].set_ylabel('Density')

# Plot 2: Exponential
axes[0, 1].hist(exp_samples, bins=30, density=True, alpha=0.7, edgecolor='black')
x_range = np.linspace(0, exp_samples.max(), 100)
axes[0, 1].plot(x_range, stats.expon.pdf(x_range, scale=2.0), 'r-', linewidth=2)
axes[0, 1].set_title('Exponential(λ=0.5)')
axes[0, 1].set_xlabel('Value')

# Plot 3: Binomial
axes[0, 2].hist(binom_samples, bins=range(12), density=True, alpha=0.7, edgecolor='black', align='left')
x_vals = range(11)
axes[0, 2].plot(x_vals, stats.binom.pmf(x_vals, 10, 0.3), 'ro-', linewidth=2)
axes[0, 2].set_title('Binomial(n=10, p=0.3)')
axes[0, 2].set_xlabel('Value')

# Plot 4: Poisson
axes[1, 0].hist(poisson_samples, bins=range(15), density=True, alpha=0.7, edgecolor='black', align='left')
x_vals = range(15)
axes[1, 0].plot(x_vals, stats.poisson.pmf(x_vals, 4.5), 'ro-', linewidth=2)
axes[1, 0].set_title('Poisson(λ=4.5)')
axes[1, 0].set_xlabel('Value')

# Plot 5: Uniform
axes[1, 1].hist(uniform_samples, bins=30, density=True, alpha=0.7, edgecolor='black')
axes[1, 1].axhline(y=1, color='r', linewidth=2)
axes[1, 1].set_title('Uniform(0, 1)')
axes[1, 1].set_xlabel('Value')
axes[1, 1].set_ylim([0, 1.5])

# Plot 6: Q-Q plot for normality check
axes[1, 2].scatter(*stats.probplot(normal_samples, dist="norm")[0], alpha=0.5)
axes[1, 2].plot([-3, 3], [-3, 3], 'r--', linewidth=2)
axes[1, 2].set_title('Q-Q Plot (Normal samples)')
axes[1, 2].set_xlabel('Theoretical Quantiles')
axes[1, 2].set_ylabel('Sample Quantiles')

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/10.Simulation/distribution_simulation.png', dpi=150)
print("\nVisualization saved as distribution_simulation.png")
plt.close()
