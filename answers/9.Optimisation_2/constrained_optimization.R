# Constrained Optimization in R
# Using optim() and constrOptim() for optimization with constraints

cat("=== Constrained Optimization ===\n\n")

# Example 1: Optimization with Box Constraints
cat("--- Example 1: Minimize f(x,y) = x² + y² with bounds ---\n")
cat("Bounds: 1 ≤ x ≤ 5, -2 ≤ y ≤ 2\n\n")

objective.simple <- function(x) {
  return(x[1]^2 + x[2]^2)
}

# optim with L-BFGS-B method supports bounds
result.bounds <- optim(c(3, 3), objective.simple, method="L-BFGS-B",
                       lower=c(1, -2), upper=c(5, 2))

cat(sprintf("Optimal solution: x = [%.4f, %.4f]\n", result.bounds$par[1], result.bounds$par[2]))
cat(sprintf("Optimal value: f(x) = %.6f\n", result.bounds$value))
cat("Without bounds, minimum would be at (0, 0)\n\n")

# Example 2: Linear Inequality Constraints using constrOptim
cat("--- Example 2: Constrained Optimization with constrOptim ---\n")
cat("Minimize f(x,y) = (x-2)² + (y-1)²\n")
cat("Subject to: x + y ≥ 3\n\n")

objective.quadratic <- function(x) {
  return((x[1] - 2)^2 + (x[2] - 1)^2)
}

# Constraints: ui %*% x - ci >= 0
# For x + y >= 3: [1, 1] %*% x - 3 >= 0
ui <- matrix(c(1, 1), nrow=1)
ci <- 3

result.constr <- constrOptim(c(0, 0), objective.quadratic, NULL,
                              ui=ui, ci=ci)

cat(sprintf("Optimal solution: x = [%.4f, %.4f]\n", result.constr$par[1], result.constr$par[2]))
cat(sprintf("Optimal value: f(x) = %.6f\n", result.constr$value))
cat(sprintf("Verification: x + y = %.6f\n\n", sum(result.constr$par)))

# Example 3: Penalty Method
cat("--- Example 3: Penalty Method (Alternative) ---\n")
cat("Minimize f(x,y) = x² + y² + penalty·(x + y - 1)²\n\n")

penalized.objective <- function(x, penalty=100) {
  return(x[1]^2 + x[2]^2 + penalty * (x[1] + x[2] - 1)^2)
}

penalties <- c(1, 10, 100, 1000)
cat(sprintf("%-10s %-10s %-10s %-15s %-20s\n",
            "Penalty", "x", "y", "f(x,y)", "Constraint violation"))
cat(paste(rep("-", 70), collapse=""), "\n")

for(pen in penalties) {
  result.pen <- optim(c(0, 0), function(x) penalized.objective(x, pen))
  violation <- abs(result.pen$par[1] + result.pen$par[2] - 1)
  cat(sprintf("%-10d %-10.4f %-10.4f %-15.6f %-20.6e\n",
              pen, result.pen$par[1], result.pen$par[2],
              sum(result.pen$par^2), violation))
}

cat("\nAs penalty increases, solution approaches constrained optimum (0.5, 0.5)\n")
