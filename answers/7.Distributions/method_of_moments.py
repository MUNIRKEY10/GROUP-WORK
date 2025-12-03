"""
Method of Moments Estimation
Estimates distribution parameters by matching theoretical and sample moments
"""
import numpy as np
from scipy import stats
from scipy.optimize import minimize

# Generate sample data from Gamma distribution
np.random.seed(42)
true_shape, true_scale = 5, 2
sample_data = np.random.gamma(true_shape, true_scale, 1000)

print("=== Method of Moments: Closed Form ===\n")
print(f"True parameters: shape={true_shape}, scale={true_scale}")
print(f"Sample mean: {np.mean(sample_data):.4f}")
print(f"Sample variance: {np.var(sample_data, ddof=1):.4f}")

# Method of Moments for Gamma Distribution (Closed Form)
def gamma_est_MM(x):
    """
    Estimate Gamma parameters using method of moments
    For Gamma distribution:
    - E[X] = shape * scale
    - Var[X] = shape * scale^2

    Solving:
    - shape = mean^2 / variance
    - scale = variance / mean
    """
    m = np.mean(x)
    v = np.var(x, ddof=1)

    shape = m**2 / v
    scale = v / m

    return {'shape': shape, 'scale': scale}

mm_estimates = gamma_est_MM(sample_data)
print(f"\nMethod of Moments estimates:")
print(f"  shape = {mm_estimates['shape']:.4f}")
print(f"  scale = {mm_estimates['scale']:.4f}")

# Verify the estimates
print(f"\nVerification:")
theoretical_mean = mm_estimates['shape'] * mm_estimates['scale']
theoretical_var = mm_estimates['shape'] * mm_estimates['scale']**2
print(f"  Theoretical mean: {theoretical_mean:.4f} (sample: {np.mean(sample_data):.4f})")
print(f"  Theoretical var:  {theoretical_var:.4f} (sample: {np.var(sample_data, ddof=1):.4f})")

print("\n" + "="*60)
print("=== Method of Moments: Numerical Optimization ===\n")

# Helper functions for gamma distribution moments
def gamma_mean(shape, scale):
    return shape * scale

def gamma_var(shape, scale):
    return shape * scale**2

# Discrepancy function to minimize
def gamma_discrepancy(params, x):
    """
    Calculate squared discrepancy between theoretical and sample moments
    """
    shape, scale = params

    if shape <= 0 or scale <= 0:
        return 1e10  # Return large value for invalid parameters

    mean_discrepancy = (np.mean(x) - gamma_mean(shape, scale))**2
    var_discrepancy = (np.var(x, ddof=1) - gamma_var(shape, scale))**2

    return mean_discrepancy + var_discrepancy

# Initial guess
initial_params = [1.0, 1.0]

# Optimize using scipy.optimize.minimize
result = minimize(gamma_discrepancy, initial_params, args=(sample_data,),
                 method='Nelder-Mead')

print(f"Optimization result:")
print(f"  Success: {result.success}")
print(f"  shape = {result.x[0]:.4f}")
print(f"  scale = {result.x[1]:.4f}")
print(f"  Discrepancy: {result.fun:.6e}")

# Compare both methods
print("\n" + "="*60)
print("=== Comparison ===\n")
print(f"{'Method':<30} {'Shape':<10} {'Scale':<10}")
print(f"{'-'*50}")
print(f"{'True values':<30} {true_shape:<10.4f} {true_scale:<10.4f}")
print(f"{'Closed form MM':<30} {mm_estimates['shape']:<10.4f} {mm_estimates['scale']:<10.4f}")
print(f"{'Numerical MM':<30} {result.x[0]:<10.4f} {result.x[1]:<10.4f}")
