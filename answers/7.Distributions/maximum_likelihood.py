"""
Maximum Likelihood Estimation (MLE)
Estimates distribution parameters by maximizing the likelihood function
"""
import numpy as np
from scipy import stats
from scipy.optimize import minimize

# Generate sample data from Gamma distribution
np.random.seed(42)
true_shape, true_scale = 5, 2
sample_data = np.random.gamma(true_shape, true_scale, 1000)

print("=== Maximum Likelihood Estimation ===\n")
print(f"True parameters: shape={true_shape}, scale={true_scale}")
print(f"Sample size: {len(sample_data)}")

# Define log-likelihood function for Exponential distribution
def loglike_exp(params, x):
    """
    Log-likelihood for exponential distribution
    """
    rate = params[0]

    if rate <= 0:
        return 1e10  # Return large value for invalid parameters

    # Sum of log densities (using scale = 1/rate)
    return -np.sum(stats.expon.logpdf(x, scale=1/rate))

# MLE for Exponential (for demonstration)
exp_data = np.random.exponential(2.0, 100)
result_exp = minimize(loglike_exp, [0.5], args=(exp_data,), method='L-BFGS-B',
                      bounds=[(0.001, None)])

print("\n--- Exponential Distribution MLE ---")
print(f"Estimated rate: {result_exp.x[0]:.4f}")
print(f"True rate (1/scale): {1/2.0:.4f}")
print(f"MLE using mean: {1/np.mean(exp_data):.4f}")

# Define log-likelihood function for Gamma distribution
def loglike_gamma(params, x):
    """
    Log-likelihood for gamma distribution
    We minimize the negative log-likelihood
    """
    shape, scale = params

    if shape <= 0 or scale <= 0:
        return 1e10

    # Sum of log densities
    return -np.sum(stats.gamma.logpdf(x, a=shape, scale=scale))

# Manual MLE for Gamma
print("\n--- Gamma Distribution MLE (Manual) ---")
initial_params = [1.0, 1.0]
result = minimize(loglike_gamma, initial_params, args=(sample_data,),
                 method='L-BFGS-B', bounds=[(0.001, None), (0.001, None)])

print(f"Optimization success: {result.success}")
print(f"Estimated shape: {result.x[0]:.4f}")
print(f"Estimated scale: {result.x[1]:.4f}")
print(f"Negative log-likelihood: {result.fun:.4f}")

# Using scipy's built-in fit method
print("\n--- Gamma Distribution MLE (scipy.stats) ---")
shape_fit, loc_fit, scale_fit = stats.gamma.fit(sample_data, floc=0)
print(f"Estimated shape: {shape_fit:.4f}")
print(f"Estimated scale: {scale_fit:.4f}")

# Method of Moments for comparison
print("\n--- Method of Moments (for comparison) ---")
m = np.mean(sample_data)
v = np.var(sample_data, ddof=1)
mm_shape = m**2 / v
mm_scale = v / m
print(f"Estimated shape: {mm_shape:.4f}")
print(f"Estimated scale: {mm_scale:.4f}")

# Comparison
print("\n" + "="*70)
print("=== Comparison ===\n")
print(f"{'Method':<30} {'Shape':<15} {'Scale':<15}")
print(f"{'-'*70}")
print(f"{'True values':<30} {true_shape:<15.4f} {true_scale:<15.4f}")
print(f"{'MLE (manual)':<30} {result.x[0]:<15.4f} {result.x[1]:<15.4f}")
print(f"{'MLE (scipy)':<30} {shape_fit:<15.4f} {scale_fit:<15.4f}")
print(f"{'Method of Moments':<30} {mm_shape:<15.4f} {mm_scale:<15.4f}")

# Log-likelihood comparison
ll_true = -loglike_gamma([true_shape, true_scale], sample_data)
ll_mle = -result.fun
ll_mm = -loglike_gamma([mm_shape, mm_scale], sample_data)

print(f"\n{'Method':<30} {'Log-Likelihood':<15}")
print(f"{'-'*70}")
print(f"{'True parameters':<30} {ll_true:<15.4f}")
print(f"{'MLE':<30} {ll_mle:<15.4f}")
print(f"{'Method of Moments':<30} {ll_mm:<15.4f}")

print("\nMLE maximizes log-likelihood")
