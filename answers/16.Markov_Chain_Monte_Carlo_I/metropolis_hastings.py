"""
Metropolis-Hastings Algorithm
MCMC sampling using proposal distribution and acceptance probability
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

print("=== Metropolis-Hastings MCMC ===\n")

# Target distribution: mixture of normals
def target_density(x):
    return 0.3*norm.pdf(x, -2, 0.8) + 0.7*norm.pdf(x, 3, 1.5)

# Metropolis-Hastings algorithm
def metropolis_hastings(target, n_iterations, proposal_std=1.0):
    samples = np.zeros(n_iterations)
    x_current = 0.0  # Initial value
    n_accepted = 0

    for i in range(n_iterations):
        # Propose new value
        x_proposed = x_current + np.random.normal(0, proposal_std)

        # Acceptance probability
        alpha = min(1, target(x_proposed) / target(x_current))

        # Accept or reject
        if np.random.rand() < alpha:
            x_current = x_proposed
            n_accepted += 1

        samples[i] = x_current

    acceptance_rate = n_accepted / n_iterations
    return samples, acceptance_rate

# Run MCMC
n_iter = 10000
samples, acc_rate = metropolis_hastings(target_density, n_iter)

print(f"Acceptance rate: {acc_rate:.3f}")
print(f"Sample mean: {np.mean(samples[1000:]):.3f}")  # Burn-in first 1000

# Visualization
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

# Trace plot
axes[0].plot(samples[:500])
axes[0].set_title('Trace Plot (first 500 iterations)')
axes[0].set_xlabel('Iteration')

# Histogram vs true density
x_range = np.linspace(-5, 8, 200)
axes[1].hist(samples[1000:], bins=50, density=True, alpha=0.5, label='MCMC samples')
axes[1].plot(x_range, [target_density(x) for x in x_range], 'r-', linewidth=2, label='True density')
axes[1].set_title('Samples vs Target Distribution')
axes[1].legend()

# Autocorrelation
from pandas.plotting import autocorrelation_plot
axes[2].acorr(samples[1000:]-np.mean(samples[1000:]), maxlags=100)
axes[2].set_title('Autocorrelation')

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/16.Markov_Chain_Monte_Carlo_I/metropolis_hastings.png', dpi=150)
print("Visualization saved")
plt.close()
