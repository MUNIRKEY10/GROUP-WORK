"""
Gibbs Sampling
MCMC method sampling from conditional distributions sequentially
"""
import numpy as np
import matplotlib.pyplot as plt

print("=== Gibbs Sampling ===\n")

# Bivariate normal with correlation
rho = 0.8
n_iterations = 5000

# Gibbs sampler for bivariate normal
samples = np.zeros((n_iterations, 2))
x, y = 0, 0  # Initial values

for i in range(n_iterations):
    # Sample x | y
    x = np.random.normal(rho * y, np.sqrt(1 - rho**2))
    # Sample y | x
    y = np.random.normal(rho * x, np.sqrt(1 - rho**2))

    samples[i] = [x, y]

print(f"Sample correlation: {np.corrcoef(samples[1000:].T)[0,1]:.3f}")
print(f"True correlation: {rho}\n")

# Visualization
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
axes[0].plot(samples[:500, 0], samples[:500, 1], 'b-', alpha=0.3, linewidth=0.5)
axes[0].scatter(samples[:500, 0], samples[:500, 1], c=range(500), cmap='viridis', s=5)
axes[0].set_title('Gibbs Sampling Path (first 500)')
axes[0].set_xlabel('X')
axes[0].set_ylabel('Y')

axes[1].scatter(samples[1000:, 0], samples[1000:, 1], alpha=0.3, s=1)
axes[1].set_title('Samples (after burn-in)')
axes[1].set_xlabel('X')
axes[1].set_ylabel('Y')

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/17.Markov_Chain_Monte_Carlo_II/gibbs_sampling.png', dpi=150)
print("Visualization saved")
plt.close()
