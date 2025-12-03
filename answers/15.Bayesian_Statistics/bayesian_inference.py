"""
Bayesian Inference
Updating beliefs using Bayes' theorem: posterior ∝ likelihood × prior
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta, binom

print("=== Bayesian Inference ===\n")

# Example: Estimating coin flip probability
# Prior: Beta(2, 2) - slightly informed prior
# Data: 7 heads out of 10 flips

n_flips = 10
n_heads = 7

# Prior parameters
alpha_prior, beta_prior = 2, 2

# Posterior parameters (conjugate: Beta + Binomial = Beta)
alpha_post = alpha_prior + n_heads
beta_post = beta_prior + (n_flips - n_heads)

print(f"Data: {n_heads} heads in {n_flips} flips")
print(f"Prior: Beta({alpha_prior}, {beta_prior})")
print(f"Posterior: Beta({alpha_post}, {beta_post})")
print(f"Posterior mean: {alpha_post/(alpha_post + beta_post):.3f}\n")

# Visualization
p_vals = np.linspace(0, 1, 200)
prior = beta.pdf(p_vals, alpha_prior, beta_prior)
likelihood = binom.pmf(n_heads, n_flips, p_vals)
posterior = beta.pdf(p_vals, alpha_post, beta_post)

plt.figure(figsize=(10, 6))
plt.plot(p_vals, prior, 'b--', label='Prior', linewidth=2)
plt.plot(p_vals, likelihood/np.max(likelihood)*np.max(posterior), 'g:', label='Likelihood (scaled)', linewidth=2)
plt.plot(p_vals, posterior, 'r-', label='Posterior', linewidth=2)
plt.axvline(n_heads/n_flips, color='gray', linestyle='--', label=f'MLE = {n_heads/n_flips}')
plt.xlabel('Probability of Heads')
plt.ylabel('Density')
plt.title('Bayesian Updating')
plt.legend()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/15.Bayesian_Statistics/bayesian_inference.png', dpi=150)
print("Visualization saved")
plt.close()
