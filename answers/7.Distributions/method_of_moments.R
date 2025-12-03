# Method of Moments Estimation
# Estimates distribution parameters by matching theoretical and sample moments

# Generate sample data from Gamma distribution
set.seed(42)
true.shape <- 5
true.scale <- 2
sample.data <- rgamma(1000, shape=true.shape, scale=true.scale)

cat("=== Method of Moments: Closed Form ===\n\n")
cat(sprintf("True parameters: shape=%d, scale=%d\n", true.shape, true.scale))
cat(sprintf("Sample mean: %.4f\n", mean(sample.data)))
cat(sprintf("Sample variance: %.4f\n", var(sample.data)))

# Method of Moments for Gamma Distribution (Closed Form)
gamma.est_MM <- function(x) {
  # Estimate Gamma parameters using method of moments
  # For Gamma distribution:
  # - E[X] = shape * scale
  # - Var[X] = shape * scale^2
  #
  # Solving:
  # - shape = mean^2 / variance
  # - scale = variance / mean

  m <- mean(x)
  v <- var(x)

  shape <- m^2 / v
  scale <- v / m

  return(c(shape=shape, scale=scale))
}

mm.estimates <- gamma.est_MM(sample.data)
cat(sprintf("\nMethod of Moments estimates:\n"))
cat(sprintf("  shape = %.4f\n", mm.estimates["shape"]))
cat(sprintf("  scale = %.4f\n", mm.estimates["scale"]))

# Verify the estimates
cat(sprintf("\nVerification:\n"))
theoretical.mean <- mm.estimates["shape"] * mm.estimates["scale"]
theoretical.var <- mm.estimates["shape"] * mm.estimates["scale"]^2
cat(sprintf("  Theoretical mean: %.4f (sample: %.4f)\n",
            theoretical.mean, mean(sample.data)))
cat(sprintf("  Theoretical var:  %.4f (sample: %.4f)\n",
            theoretical.var, var(sample.data)))

cat("\n")
cat(paste(rep("=", 60), collapse=""), "\n")
cat("=== Method of Moments: Numerical Optimization ===\n\n")

# Helper functions for gamma distribution moments
gamma.mean <- function(shape, scale) {
  return(shape * scale)
}

gamma.var <- function(shape, scale) {
  return(shape * scale^2)
}

# Discrepancy function to minimize
gamma.discrepancy <- function(params, x) {
  # Calculate squared discrepancy between theoretical and sample moments
  shape <- params[1]
  scale <- params[2]

  if(shape <= 0 || scale <= 0) {
    return(1e10)  # Return large value for invalid parameters
  }

  mean.discrepancy <- (mean(x) - gamma.mean(shape, scale))^2
  var.discrepancy <- (var(x) - gamma.var(shape, scale))^2

  return(mean.discrepancy + var.discrepancy)
}

# Initial guess
initial.params <- c(1.0, 1.0)

# Optimize using optim
result <- optim(initial.params, gamma.discrepancy, x=sample.data,
                method="Nelder-Mead")

cat(sprintf("Optimization result:\n"))
cat(sprintf("  Convergence: %d\n", result$convergence))
cat(sprintf("  shape = %.4f\n", result$par[1]))
cat(sprintf("  scale = %.4f\n", result$par[2]))
cat(sprintf("  Discrepancy: %.6e\n", result$value))

# Compare both methods
cat("\n")
cat(paste(rep("=", 60), collapse=""), "\n")
cat("=== Comparison ===\n\n")
cat(sprintf("%-30s %-10s %-10s\n", "Method", "Shape", "Scale"))
cat(paste(rep("-", 50), collapse=""), "\n")
cat(sprintf("%-30s %-10.4f %-10.4f\n", "True values", true.shape, true.scale))
cat(sprintf("%-30s %-10.4f %-10.4f\n", "Closed form MM",
            mm.estimates["shape"], mm.estimates["scale"]))
cat(sprintf("%-30s %-10.4f %-10.4f\n", "Numerical MM",
            result$par[1], result$par[2]))
