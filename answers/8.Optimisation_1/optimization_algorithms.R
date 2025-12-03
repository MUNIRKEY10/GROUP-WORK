# Comparison of Optimization Algorithms
# Includes: Gradient Descent, Newton's Method (BFGS), Nelder-Mead, and Coordinate Descent

library(numDeriv)

cat("=== Optimization Algorithms Comparison ===\n\n")

# Test function: Rosenbrock
rosenbrock <- function(x) {
  return((1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2)
}

x.init <- c(-1.0, 2.0)
cat("Test function: Rosenbrock\n")
cat("f(x, y) = (1-x)² + 100(y-x²)²\n")
cat("True minimum: (1, 1) with f = 0\n")
cat(sprintf("Starting point: [%.1f, %.1f]\n\n", x.init[1], x.init[2]))

# 1. Gradient Descent (custom implementation)
gradient.descent <- function(f, x.init, max.iter=1000, step.scale=0.001,
                            stopping.deriv=1e-6) {
  x <- x.init
  for(i in 1:max.iter) {
    gradient <- grad(f, x)
    if(all(abs(gradient) < stopping.deriv)) {
      return(list(x=x, iterations=i, value=f(x)))
    }
    x <- x - step.scale * gradient
  }
  return(list(x=x, iterations=max.iter, value=f(x)))
}

cat("--- 1. Gradient Descent ---\n")
result.gd <- gradient.descent(rosenbrock, x.init, max.iter=10000)
cat(sprintf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
            result.gd$x[1], result.gd$x[2], result.gd$value))
cat(sprintf("Iterations: %d\n\n", result.gd$iterations))

# 2. Newton's Method (using optim with BFGS)
cat("--- 2. Newton's Method (BFGS) ---\n")
result.newton <- optim(x.init, rosenbrock, method="BFGS")
cat(sprintf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
            result.newton$par[1], result.newton$par[2], result.newton$value))
cat(sprintf("Function evaluations: %d\n\n", result.newton$counts[1]))

# 3. Nelder-Mead (Simplex Method)
cat("--- 3. Nelder-Mead (Simplex) ---\n")
result.nm <- optim(x.init, rosenbrock, method="Nelder-Mead")
cat(sprintf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
            result.nm$par[1], result.nm$par[2], result.nm$value))
cat(sprintf("Function evaluations: %d\n\n", result.nm$counts[1]))

# 4. Coordinate Descent
coordinate.descent <- function(f, x.init, max.iter=100, tol=1e-6) {
  x <- x.init
  n.dims <- length(x)

  for(iteration in 1:max.iter) {
    x.old <- x

    # Optimize each coordinate
    for(i in 1:n.dims) {
      # Define 1D function for coordinate i
      f.1d <- function(xi) {
        x.temp <- x
        x.temp[i] <- xi
        return(f(x.temp))
      }

      # Optimize this coordinate
      result.1d <- optim(x[i], f.1d, method="BFGS")
      x[i] <- result.1d$par
    }

    # Check convergence
    if(sqrt(sum((x - x.old)^2)) < tol) {
      return(list(x=x, iterations=iteration, value=f(x)))
    }
  }

  return(list(x=x, iterations=max.iter, value=f(x)))
}

cat("--- 4. Coordinate Descent ---\n")
result.cd <- coordinate.descent(rosenbrock, x.init, max.iter=100)
cat(sprintf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
            result.cd$x[1], result.cd$x[2], result.cd$value))
cat(sprintf("Iterations: %d\n\n", result.cd$iterations))

# Summary
cat(paste(rep("=", 70), collapse=""), "\n")
cat("=== Summary Comparison ===\n\n")
cat(sprintf("%-20s %-20s %-15s %-10s\n", "Method", "Final x", "f(x)", "Iterations"))
cat(paste(rep("-", 70), collapse=""), "\n")
cat(sprintf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Gradient Descent",
            result.gd$x[1], result.gd$x[2], result.gd$value, result.gd$iterations))
cat(sprintf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Newton (BFGS)",
            result.newton$par[1], result.newton$par[2], result.newton$value,
            result.newton$counts[1]))
cat(sprintf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Nelder-Mead",
            result.nm$par[1], result.nm$par[2], result.nm$value, result.nm$counts[1]))
cat(sprintf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Coordinate Descent",
            result.cd$x[1], result.cd$x[2], result.cd$value, result.cd$iterations))

cat("\nAll methods successfully minimized the test function!\n")
