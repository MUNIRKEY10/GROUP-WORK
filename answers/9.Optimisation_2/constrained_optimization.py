"""
Constrained Optimization
Using scipy.optimize for optimization with constraints (bounds and constraints)
"""
import numpy as np
from scipy.optimize import minimize, LinearConstraint, NonlinearConstraint

print("=== Constrained Optimization ===\n")

# Example 1: Optimization with Bounds
print("--- Example 1: Minimize f(x,y) = x² + y² with bounds ---")
print("Bounds: 1 ≤ x ≤ 5, -2 ≤ y ≤ 2\n")

def objective_simple(x):
    return x[0]**2 + x[1]**2

bounds = [(1, 5), (-2, 2)]
x0 = [3, 3]

result_bounds = minimize(objective_simple, x0, bounds=bounds)
print(f"Starting point: {x0}")
print(f"Optimal solution: x = {result_bounds.x}")
print(f"Optimal value: f(x) = {result_bounds.fun:.6f}")
print(f"Without bounds, minimum would be at (0, 0)\n")

# Example 2: Linear Equality Constraint
print("--- Example 2: Minimize f(x,y) = (x-2)² + (y-1)² ---")
print("Subject to: x + y = 3\n")

def objective_quadratic(x):
    return (x[0] - 2)**2 + (x[1] - 1)**2

# Linear constraint: x + y = 3 → Ax = b where A = [1, 1], b = 3
linear_constraint = LinearConstraint([[1, 1]], [3], [3])

x0 = [0, 0]
result_linear = minimize(objective_quadratic, x0, constraints=linear_constraint)
print(f"Starting point: {x0}")
print(f"Optimal solution: x = {result_linear.x}")
print(f"Optimal value: f(x) = {result_linear.fun:.6f}")
print(f"Verification: x + y = {result_linear.x[0] + result_linear.x[1]:.6f}\n")

# Example 3: Nonlinear Constraint
print("--- Example 3: Minimize f(x,y) = x² + y² ---")
print("Subject to: x² + y² ≥ 1 (outside unit circle)\n")

def constraint_circle(x):
    return x[0]**2 + x[1]**2  # Must be ≥ 1

nonlinear_constraint = NonlinearConstraint(constraint_circle, 1, np.inf)

x0 = [2, 2]
result_nonlinear = minimize(objective_simple, x0, constraints=nonlinear_constraint)
print(f"Starting point: {x0}")
print(f"Optimal solution: x = {result_nonlinear.x}")
print(f"Optimal value: f(x) = {result_nonlinear.fun:.6f}")
print(f"Distance from origin: {np.sqrt(result_nonlinear.x[0]**2 + result_nonlinear.x[1]**2):.6f}")
print(f"Optimal point is on the boundary (unit circle)\n")

# Example 4: Lagrange Multipliers (analytical solution for comparison)
print("--- Example 4: Lagrange Multipliers (Analytical) ---")
print("Minimize f(x,y) = x² + y², subject to x + y = 1\n")
print("Lagrangian: L(x,y,λ) = x² + y² - λ(x + y - 1)")
print("∂L/∂x = 2x - λ = 0 → x = λ/2")
print("∂L/∂y = 2y - λ = 0 → y = λ/2")
print("∂L/∂λ = -(x + y - 1) = 0 → x + y = 1")
print("Solving: x = y = 0.5, λ = 1")
print(f"Analytical solution: x = 0.5, y = 0.5, f(x) = 0.5\n")

# Verify with numerical optimization
constraint = LinearConstraint([[1, 1]], [1], [1])
result_verify = minimize(objective_simple, [0, 0], constraints=constraint)
print(f"Numerical solution: x = {result_verify.x}")
print(f"Numerical value: f(x) = {result_verify.fun:.6f}")

# Example 5: Penalized Optimization (alternative approach)
print("\n--- Example 5: Penalty Method (Alternative) ---")
print("Minimize f(x,y) = x² + y² + penalty·(x + y - 1)²\n")

def penalized_objective(x, penalty=100):
    return x[0]**2 + x[1]**2 + penalty * (x[0] + x[1] - 1)**2

penalties = [1, 10, 100, 1000]
print(f"{'Penalty':<10} {'x':<10} {'y':<10} {'f(x,y)':<15} {'Constraint violation':<20}")
print("-" * 70)

for pen in penalties:
    result_pen = minimize(lambda x: penalized_objective(x, pen), [0, 0])
    violation = abs(result_pen.x[0] + result_pen.x[1] - 1)
    print(f"{pen:<10} {result_pen.x[0]:<10.4f} {result_pen.x[1]:<10.4f} "
          f"{result_pen.x[0]**2 + result_pen.x[1]**2:<15.6f} {violation:<20.6e}")

print("\nAs penalty increases, solution approaches constrained optimum (0.5, 0.5)")
