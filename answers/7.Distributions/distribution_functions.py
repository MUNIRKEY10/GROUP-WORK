"""
Distribution Functions: d, p, q, r pattern
Demonstrates the four types of distribution functions:
- d: Density (PDF/PMF)
- p: Probability (CDF)
- q: Quantile (inverse CDF)
- r: Random variates
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Example with Exponential Distribution
print("=== Exponential Distribution Functions ===\n")

# Define range
x_range = np.linspace(0, 8, 160)

# 1. Density function (PDF)
print("1. Density function (dexp equivalent):")
pdf_1 = stats.expon.pdf(x_range, scale=1.0)  # rate=1, scale=1/rate
pdf_2 = stats.expon.pdf(x_range, scale=2.0)  # rate=0.5
pdf_3 = stats.expon.pdf(x_range, scale=5.0)  # rate=0.2
print(f"   PDF at x=1 with rate=1: {stats.expon.pdf(1, scale=1.0):.4f}")

# 2. Cumulative distribution function (CDF)
print("\n2. Cumulative distribution function (pexp equivalent):")
cdf_1 = stats.expon.cdf(x_range, scale=1.0)
cdf_2 = stats.expon.cdf(x_range, scale=2.0)
cdf_3 = stats.expon.cdf(x_range, scale=5.0)
print(f"   P(X < 1) with rate=1: {stats.expon.cdf(1, scale=1.0):.4f}")

# 3. Quantile function (inverse CDF)
print("\n3. Quantile function (qexp equivalent):")
q_value = stats.expon.ppf(0.5, scale=1.0)
print(f"   Median (50th percentile) with rate=1: {q_value:.4f}")
print(f"   95th percentile with rate=1: {stats.expon.ppf(0.95, scale=1.0):.4f}")

# 4. Random variates
print("\n4. Random variates (rexp equivalent):")
np.random.seed(42)
random_samples = stats.expon.rvs(scale=1.0, size=10)
print(f"   10 random samples: {random_samples}")

# Visualization
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Plot 1: PDF
axes[0, 0].plot(x_range, pdf_1, 'b-', label='rate=1.0')
axes[0, 0].plot(x_range, pdf_2, 'r-', label='rate=0.5')
axes[0, 0].plot(x_range, pdf_3, 'g-', label='rate=0.2')
axes[0, 0].set_title('Exponential PDF (Density)')
axes[0, 0].set_xlabel('x')
axes[0, 0].set_ylabel('f(x)')
axes[0, 0].legend()
axes[0, 0].grid(True, alpha=0.3)

# Plot 2: CDF
axes[0, 1].plot(x_range, cdf_1, 'b-', label='rate=1.0')
axes[0, 1].plot(x_range, cdf_2, 'r-', label='rate=0.5')
axes[0, 1].plot(x_range, cdf_3, 'g-', label='rate=0.2')
axes[0, 1].set_title('Exponential CDF (Probability)')
axes[0, 1].set_xlabel('x')
axes[0, 1].set_ylabel('P(X < x)')
axes[0, 1].legend()
axes[0, 1].grid(True, alpha=0.3)

# Plot 3: Normal distribution examples
x_norm = np.linspace(-4, 4, 200)
axes[1, 0].plot(x_norm, stats.norm.pdf(x_norm, 0, 1), 'b-', label='μ=0, σ=1')
axes[1, 0].plot(x_norm, stats.norm.pdf(x_norm, 0, 0.5), 'r-', label='μ=0, σ=0.5')
axes[1, 0].plot(x_norm, stats.norm.pdf(x_norm, 1, 1), 'g-', label='μ=1, σ=1')
axes[1, 0].set_title('Normal Distribution PDF')
axes[1, 0].set_xlabel('x')
axes[1, 0].set_ylabel('f(x)')
axes[1, 0].legend()
axes[1, 0].grid(True, alpha=0.3)

# Plot 4: Gamma distribution examples
x_gamma = np.linspace(0, 20, 200)
axes[1, 1].plot(x_gamma, stats.gamma.pdf(x_gamma, a=2, scale=2), 'b-', label='shape=2, scale=2')
axes[1, 1].plot(x_gamma, stats.gamma.pdf(x_gamma, a=5, scale=1), 'r-', label='shape=5, scale=1')
axes[1, 1].plot(x_gamma, stats.gamma.pdf(x_gamma, a=1, scale=2), 'g-', label='shape=1, scale=2')
axes[1, 1].set_title('Gamma Distribution PDF')
axes[1, 1].set_xlabel('x')
axes[1, 1].set_ylabel('f(x)')
axes[1, 1].legend()
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/distribution_functions.png', dpi=150)
print("\nVisualization saved as distribution_functions.png")
plt.close()

# Summary of common distributions
print("\n=== Common Distributions in scipy.stats ===")
print("Continuous: norm, expon, gamma, beta, chi2, t, f, uniform, lognorm, weibull_min")
print("Discrete: binom, poisson, nbinom, geom, hypergeom")
print("\nAll support: pdf/pmf, cdf, ppf, rvs methods")
