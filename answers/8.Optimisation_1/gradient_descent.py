"""
Gradient Descent Implementation
Optimization using first-order derivatives
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import approx_fprime

def gradient_descent(f, x_init, max_iterations=1000, step_scale=0.01,
                     stopping_deriv=1e-6, args=(), verbose=False):
    """
    Gradient Descent optimization algorithm

    Parameters:
    -----------
    f : callable
        Objective function to minimize
    x_init : array-like
        Initial guess for parameters
    max_iterations : int
        Maximum number of iterations
    step_scale : float
        Step size (learning rate) η
    stopping_deriv : float
        Convergence criterion for gradient magnitude
    args : tuple
        Additional arguments to pass to f
    verbose : bool
        Print progress information

    Returns:
    --------
    dict with keys:
        - argmin: final parameter values
        - final_gradient: gradient at final point
        - final_value: objective function value at final point
        - iterations: number of iterations performed
        - history: list of (iteration, x, f(x)) tuples
    """
    x = np.array(x_init, dtype=float)
    history = []

    for iteration in range(max_iterations):
        # Compute gradient using numerical approximation
        gradient = approx_fprime(x, f, 1e-8, *args)

        # Store history
        f_val = f(x, *args)
        history.append((iteration, x.copy(), f_val))

        if verbose and iteration % 100 == 0:
            print(f"Iteration {iteration}: f(x) = {f_val:.6f}, ||∇f|| = {np.linalg.norm(gradient):.6e}")

        # Check convergence
        if np.all(np.abs(gradient) < stopping_deriv):
            if verbose:
                print(f"Converged at iteration {iteration}")
            break

        # Update: θ ← θ - η∇f(θ)
        x = x - step_scale * gradient

    final_gradient = gradient
    final_value = f(x, *args)

    return {
        'argmin': x,
        'final_gradient': final_gradient,
        'final_value': final_value,
        'iterations': iteration + 1,
        'history': history
    }


# Example 1: Simple quadratic function
print("=== Example 1: Minimize f(x) = x² ===\n")

def quadratic(x):
    return x[0]**2

result = gradient_descent(quadratic, x_init=[10.0], step_scale=0.1,
                         stopping_deriv=1e-6, verbose=True)

print(f"\nFinal x: {result['argmin']}")
print(f"Final f(x): {result['final_value']:.6e}")
print(f"Iterations: {result['iterations']}")

# Example 2: Rosenbrock function (banana function)
print("\n" + "="*70)
print("=== Example 2: Minimize Rosenbrock Function ===\n")
print("f(x, y) = (1-x)² + 100(y-x²)²")
print("Global minimum at (1, 1) with f(1,1) = 0\n")

def rosenbrock(x):
    return (1 - x[0])**2 + 100 * (x[1] - x[0]**2)**2

result_rb = gradient_descent(rosenbrock, x_init=[-1.0, 2.0],
                             max_iterations=10000, step_scale=0.001,
                             stopping_deriv=1e-6, verbose=False)

print(f"Starting point: [-1.0, 2.0]")
print(f"Final x: {result_rb['argmin']}")
print(f"Final f(x): {result_rb['final_value']:.6e}")
print(f"Iterations: {result_rb['iterations']}")

# Example 3: Least squares regression
print("\n" + "="*70)
print("=== Example 3: Linear Regression via Gradient Descent ===\n")

# Generate synthetic data
np.random.seed(42)
n = 100
X_data = np.random.randn(n)
y_data = 2.5 * X_data + 1.0 + np.random.randn(n) * 0.5

def mse_linear(params, X, y):
    """Mean squared error for linear model"""
    slope, intercept = params
    predictions = slope * X + intercept
    return np.mean((y - predictions)**2)

result_reg = gradient_descent(lambda p: mse_linear(p, X_data, y_data),
                              x_init=[0.0, 0.0], max_iterations=1000,
                              step_scale=0.1, stopping_deriv=1e-6)

print(f"True parameters: slope=2.5, intercept=1.0")
print(f"Estimated parameters: slope={result_reg['argmin'][0]:.4f}, intercept={result_reg['argmin'][1]:.4f}")
print(f"Final MSE: {result_reg['final_value']:.4f}")

# Visualization
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Plot 1: Quadratic function optimization path
ax = axes[0, 0]
x_vals = np.linspace(-10, 10, 100)
ax.plot(x_vals, x_vals**2, 'b-', linewidth=2)
path = np.array([h[1][0] for h in result['history']])
ax.plot(path, path**2, 'ro-', markersize=3, linewidth=1, label='GD path')
ax.set_xlabel('x')
ax.set_ylabel('f(x)')
ax.set_title('Gradient Descent on f(x) = x²')
ax.legend()
ax.grid(True, alpha=0.3)

# Plot 2: Convergence history
ax = axes[0, 1]
iterations = [h[0] for h in result['history']]
f_values = [h[2] for h in result['history']]
ax.semilogy(iterations, f_values, 'b-', linewidth=2)
ax.set_xlabel('Iteration')
ax.set_ylabel('f(x) [log scale]')
ax.set_title('Convergence History')
ax.grid(True, alpha=0.3)

# Plot 3: Rosenbrock contour with path
ax = axes[1, 0]
x_range = np.linspace(-1.5, 1.5, 100)
y_range = np.linspace(-0.5, 2.5, 100)
X, Y = np.meshgrid(x_range, y_range)
Z = (1 - X)**2 + 100 * (Y - X**2)**2
contour = ax.contour(X, Y, Z, levels=np.logspace(-1, 3, 20), cmap='viridis')
ax.clabel(contour, inline=True, fontsize=8)

# Plot optimization path
path_x = [h[1][0] for h in result_rb['history'][::10]]  # Plot every 10th point
path_y = [h[1][1] for h in result_rb['history'][::10]]
ax.plot(path_x, path_y, 'ro-', markersize=3, linewidth=1, label='GD path')
ax.plot(1, 1, 'g*', markersize=15, label='True minimum')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_title('Rosenbrock Function Optimization')
ax.legend()

# Plot 4: Linear regression fit
ax = axes[1, 1]
ax.scatter(X_data, y_data, alpha=0.5, label='Data')
x_line = np.linspace(X_data.min(), X_data.max(), 100)
y_line = result_reg['argmin'][0] * x_line + result_reg['argmin'][1]
ax.plot(x_line, y_line, 'r-', linewidth=2, label='GD fit')
ax.set_xlabel('X')
ax.set_ylabel('y')
ax.set_title('Linear Regression via Gradient Descent')
ax.legend()
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/8.Optimisation_1/gradient_descent.png', dpi=150)
print("\nVisualization saved as gradient_descent.png")
plt.close()
