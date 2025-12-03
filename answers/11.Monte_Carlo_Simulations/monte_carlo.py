"""
Monte Carlo Simulation
Using simulation to estimate expectations and perform integration
Based on the Law of Large Numbers
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

print("=== Monte Carlo Simulation ===\n")

# Key Concept 1: Estimating Expectations using LLN
print("--- Example 1: Estimating E[X] for Normal Distribution ---")
print("True E[X] = μ = 5\n")

np.random.seed(42)
mu, sigma = 5, 2
sample_sizes = [10, 100, 1000, 10000]

print(f"{'Sample Size':<15} {'Estimated E[X]':<20} {'Error':<15}")
print("-" * 50)

for n in sample_sizes:
    samples = np.random.normal(mu, sigma, n)
    estimate = np.mean(samples)
    error = abs(estimate - mu)
    print(f"{n:<15} {estimate:<20.6f} {error:<15.6e}")

# Example 2: Monte Carlo Integration
print("\n--- Example 2: Monte Carlo Integration ---")
print("Estimate ∫₀¹ x² dx = 1/3 ≈ 0.333333\n")

def f(x):
    return x**2

n_samples = 100000
x_samples = np.random.uniform(0, 1, n_samples)
f_samples = f(x_samples)
mc_estimate = np.mean(f_samples) * (1 - 0)  # * (b - a)

print(f"True value: {1/3:.6f}")
print(f"Monte Carlo estimate (n={n_samples}): {mc_estimate:.6f}")
print(f"Error: {abs(mc_estimate - 1/3):.6e}\n")

# Example 3: Estimating π using Monte Carlo
print("--- Example 3: Estimating π ---")
print("Sample points uniformly in [0,1]×[0,1] square")
print("Count how many fall inside quarter circle\n")

n_points = 100000
x = np.random.uniform(0, 1, n_points)
y = np.random.uniform(0, 1, n_points)

inside_circle = (x**2 + y**2) <= 1
pi_estimate = 4 * np.sum(inside_circle) / n_points

print(f"True π: {np.pi:.6f}")
print(f"Monte Carlo estimate (n={n_points}): {pi_estimate:.6f}")
print(f"Error: {abs(pi_estimate - np.pi):.6e}\n")

# Example 4: Convergence visualization
print("--- Example 4: Convergence of Monte Carlo Estimates ---")

np.random.seed(42)
max_n = 10000
cumulative_means = []

samples = np.random.normal(mu, sigma, max_n)
for i in range(1, max_n + 1):
    cumulative_means.append(np.mean(samples[:i]))

# Visualization
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Plot 1: Convergence of mean estimate
axes[0, 0].plot(range(1, max_n + 1), cumulative_means, 'b-', alpha=0.7)
axes[0, 0].axhline(y=mu, color='r', linestyle='--', linewidth=2, label=f'True mean = {mu}')
axes[0, 0].set_xlabel('Sample Size')
axes[0, 0].set_ylabel('Estimated Mean')
axes[0, 0].set_title('Convergence of Monte Carlo Estimate')
axes[0, 0].legend()
axes[0, 0].grid(True, alpha=0.3)
axes[0, 0].set_xscale('log')

# Plot 2: Integration example
x_plot = np.linspace(0, 1, 1000)
axes[0, 1].plot(x_plot, f(x_plot), 'b-', linewidth=2, label='f(x) = x²')
axes[0, 1].fill_between(x_plot, f(x_plot), alpha=0.3)
axes[0, 1].set_xlabel('x')
axes[0, 1].set_ylabel('f(x)')
axes[0, 1].set_title(f'Monte Carlo Integration: ∫₀¹ x² dx')
axes[0, 1].legend()
axes[0, 1].grid(True, alpha=0.3)
axes[0, 1].text(0.5, 0.5, f'MC estimate: {mc_estimate:.4f}\nTrue value: {1/3:.4f}',
                bbox=dict(boxstyle='round', facecolor='wheat'))

# Plot 3: π estimation visualization
axes[1, 0].scatter(x[inside_circle][:1000], y[inside_circle][:1000],
                  c='blue', s=1, alpha=0.5, label='Inside')
axes[1, 0].scatter(x[~inside_circle][:1000], y[~inside_circle][:1000],
                  c='red', s=1, alpha=0.5, label='Outside')
theta = np.linspace(0, np.pi/2, 100)
axes[1, 0].plot(np.cos(theta), np.sin(theta), 'k-', linewidth=2)
axes[1, 0].set_xlabel('x')
axes[1, 0].set_ylabel('y')
axes[1, 0].set_title(f'Estimating π: {pi_estimate:.4f}')
axes[1, 0].legend()
axes[1, 0].set_aspect('equal')

# Plot 4: Distribution of sample means (CLT)
n_experiments = 1000
sample_size = 30
sample_means = [np.mean(np.random.normal(mu, sigma, sample_size))
                for _ in range(n_experiments)]

axes[1, 1].hist(sample_means, bins=30, density=True, alpha=0.7, edgecolor='black')
# Theoretical distribution: N(μ, σ²/n)
x_range = np.linspace(min(sample_means), max(sample_means), 100)
theoretical_density = stats.norm.pdf(x_range, mu, sigma/np.sqrt(sample_size))
axes[1, 1].plot(x_range, theoretical_density, 'r-', linewidth=2, label='Theoretical')
axes[1, 1].set_xlabel('Sample Mean')
axes[1, 1].set_ylabel('Density')
axes[1, 1].set_title('Distribution of Sample Means (CLT)')
axes[1, 1].legend()
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/11.Monte_Carlo_Simulations/monte_carlo.png', dpi=150)
print("Visualization saved as monte_carlo.png")
plt.close()
