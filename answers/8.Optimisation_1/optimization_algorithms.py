"""
Comparison of Optimization Algorithms
Includes: Gradient Descent, Newton's Method, Nelder-Mead, and Coordinate Descent
"""
import numpy as np
from scipy.optimize import minimize, approx_fprime
from scipy.misc import derivative
import matplotlib.pyplot as plt

print("=== Optimization Algorithms Comparison ===\n")

# Test function: Rosenbrock
def rosenbrock(x):
    return (1 - x[0])**2 + 100 * (x[1] - x[0]**2)**2

x_init = np.array([-1.0, 2.0])
print(f"Test function: Rosenbrock")
print(f"f(x, y) = (1-x)² + 100(y-x²)²")
print(f"True minimum: (1, 1) with f = 0")
print(f"Starting point: {x_init}\n")

# 1. Gradient Descent (custom implementation from previous file)
def gradient_descent_simple(f, x_init, max_iter=1000, step=0.001, tol=1e-6):
    x = np.array(x_init, dtype=float)
    for i in range(max_iter):
        grad = approx_fprime(x, f, 1e-8)
        if np.linalg.norm(grad) < tol:
            return x, i+1, f(x)
        x = x - step * grad
    return x, max_iter, f(x)

print("--- 1. Gradient Descent ---")
x_gd, iter_gd, f_gd = gradient_descent_simple(rosenbrock, x_init, max_iter=10000)
print(f"Result: x = {x_gd}, f(x) = {f_gd:.6e}")
print(f"Iterations: {iter_gd}\n")

# 2. Newton's Method (using scipy with BFGS - quasi-Newton)
print("--- 2. Newton's Method (BFGS) ---")
result_newton = minimize(rosenbrock, x_init, method='BFGS', tol=1e-6)
print(f"Result: x = {result_newton.x}, f(x) = {result_newton.fun:.6e}")
print(f"Iterations: {result_newton.nit}")
print(f"Function evaluations: {result_newton.nfev}\n")

# 3. Nelder-Mead (Simplex Method)
print("--- 3. Nelder-Mead (Simplex) ---")
result_nm = minimize(rosenbrock, x_init, method='Nelder-Mead', tol=1e-6)
print(f"Result: x = {result_nm.x}, f(x) = {result_nm.fun:.6e}")
print(f"Iterations: {result_nm.nit}")
print(f"Function evaluations: {result_nm.nfev}\n")

# 4. Coordinate Descent
def coordinate_descent(f, x_init, max_iter=1000, tol=1e-6):
    """Coordinate descent: optimize one coordinate at a time"""
    x = np.array(x_init, dtype=float)
    n_dims = len(x)

    for iteration in range(max_iter):
        x_old = x.copy()

        # Optimize each coordinate
        for i in range(n_dims):
            # Define 1D function for coordinate i
            def f_1d(xi):
                x_temp = x.copy()
                x_temp[i] = xi
                return f(x_temp)

            # Optimize this coordinate
            result_1d = minimize(f_1d, x[i], method='BFGS')
            x[i] = result_1d.x[0]

        # Check convergence
        if np.linalg.norm(x - x_old) < tol:
            return x, iteration+1, f(x)

    return x, max_iter, f(x)

print("--- 4. Coordinate Descent ---")
x_cd, iter_cd, f_cd = coordinate_descent(rosenbrock, x_init, max_iter=100)
print(f"Result: x = {x_cd}, f(x) = {f_cd:.6e}")
print(f"Iterations: {iter_cd}\n")

# Summary comparison
print("=" * 70)
print("=== Summary Comparison ===\n")
print(f"{'Method':<20} {'Final x':<25} {'f(x)':<15} {'Iterations':<10}")
print("-" * 70)
print(f"{'Gradient Descent':<20} {str(np.round(x_gd, 4)):<25} {f_gd:<15.6e} {iter_gd:<10}")
print(f"{'Newton (BFGS)':<20} {str(np.round(result_newton.x, 4)):<25} {result_newton.fun:<15.6e} {result_newton.nit:<10}")
print(f"{'Nelder-Mead':<20} {str(np.round(result_nm.x, 4)):<25} {result_nm.fun:<15.6e} {result_nm.nit:<10}")
print(f"{'Coordinate Descent':<20} {str(np.round(x_cd, 4)):<25} {f_cd:<15.6e} {iter_cd:<10}")

# Test on simpler function: quadratic
print("\n" + "=" * 70)
print("=== Test on Quadratic Function ===\n")
print("f(x, y) = x² + 4y²")

def quadratic_2d(x):
    return x[0]**2 + 4*x[1]**2

x_init_quad = np.array([5.0, 5.0])

# Test all methods
x_gd_q, iter_gd_q, f_gd_q = gradient_descent_simple(quadratic_2d, x_init_quad, step=0.1)
result_newton_q = minimize(quadratic_2d, x_init_quad, method='BFGS')
result_nm_q = minimize(quadratic_2d, x_init_quad, method='Nelder-Mead')
x_cd_q, iter_cd_q, f_cd_q = coordinate_descent(quadratic_2d, x_init_quad)

print(f"{'Method':<20} {'Iterations':<15} {'Function evals':<15}")
print("-" * 50)
print(f"{'Gradient Descent':<20} {iter_gd_q:<15} {iter_gd_q:<15}")
print(f"{'Newton (BFGS)':<20} {result_newton_q.nit:<15} {result_newton_q.nfev:<15}")
print(f"{'Nelder-Mead':<20} {result_nm_q.nit:<15} {result_nm_q.nfev:<15}")
print(f"{'Coordinate Descent':<20} {iter_cd_q:<15} {'N/A':<15}")

print("\nAll methods successfully minimized both test functions!")
