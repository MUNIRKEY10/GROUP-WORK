# Maximum Likelihood Estimation (MLE)
# Estimates distribution parameters by maximizing the likelihood function

library(MASS)  # for fitdistr function

# Generate sample data from Gamma distribution
set.seed(42)
true.shape <- 5
true.scale <- 2
sample.data <- rgamma(1000, shape=true.shape, scale=true.scale)

cat("=== Maximum Likelihood Estimation ===\n\n")
cat(sprintf("True parameters: shape=%d, scale=%d\n", true.shape, true.scale))
cat(sprintf("Sample size: %d\n", length(sample.data)))

# Define log-likelihood function for Exponential distribution
loglike.exp <- function(rate, x) {
  # Log-likelihood for exponential distribution
  if(rate <= 0) {
    return(1e10)  # Return large value for invalid parameters
  }

  # Sum of log densities
  return(-sum(dexp(x, rate=rate, log=TRUE)))
}

# MLE for Exponential (for demonstration)
exp.data <- rexp(100, rate=0.5)  # scale = 2.0
result.exp <- optim(0.5, loglike.exp, x=exp.data,
                    method="L-BFGS-B", lower=0.001)

cat("\n--- Exponential Distribution MLE ---\n")
cat(sprintf("Estimated rate: %.4f\n", result.exp$par))
cat(sprintf("True rate (1/scale): %.4f\n", 0.5))
cat(sprintf("MLE using mean: %.4f\n", 1/mean(exp.data)))

# Define log-likelihood function for Gamma distribution
loglike.gamma <- function(params, x) {
  # Log-likelihood for gamma distribution
  # We minimize the negative log-likelihood
  shape <- params[1]
  scale <- params[2]

  if(shape <= 0 || scale <= 0) {
    return(1e10)
  }

  # Sum of log densities
  return(-sum(dgamma(x, shape=shape, scale=scale, log=TRUE)))
}

# Manual MLE for Gamma
cat("\n--- Gamma Distribution MLE (Manual) ---\n")
initial.params <- c(1.0, 1.0)
result <- optim(initial.params, loglike.gamma, x=sample.data,
                method="L-BFGS-B", lower=c(0.001, 0.001))

cat(sprintf("Optimization convergence: %d\n", result$convergence))
cat(sprintf("Estimated shape: %.4f\n", result$par[1]))
cat(sprintf("Estimated scale: %.4f\n", result$par[2]))
cat(sprintf("Negative log-likelihood: %.4f\n", result$value))

# Using MASS fitdistr
cat("\n--- Gamma Distribution MLE (fitdistr) ---\n")
fit.result <- fitdistr(sample.data, densfun="gamma")
cat(sprintf("Estimated shape: %.4f\n", fit.result$estimate["shape"]))
cat(sprintf("Estimated rate: %.4f\n", fit.result$estimate["rate"]))
cat(sprintf("Estimated scale (1/rate): %.4f\n", 1/fit.result$estimate["rate"]))

# Method of Moments for comparison
cat("\n--- Method of Moments (for comparison) ---\n")
m <- mean(sample.data)
v <- var(sample.data)
mm.shape <- m^2 / v
mm.scale <- v / m
cat(sprintf("Estimated shape: %.4f\n", mm.shape))
cat(sprintf("Estimated scale: %.4f\n", mm.scale))

# Comparison
cat("\n")
cat(paste(rep("=", 70), collapse=""), "\n")
cat("=== Comparison ===\n\n")
cat(sprintf("%-30s %-15s %-15s\n", "Method", "Shape", "Scale"))
cat(paste(rep("-", 70), collapse=""), "\n")
cat(sprintf("%-30s %-15.4f %-15.4f\n", "True values", true.shape, true.scale))
cat(sprintf("%-30s %-15.4f %-15.4f\n", "MLE (manual)", result$par[1], result$par[2]))
cat(sprintf("%-30s %-15.4f %-15.4f\n", "MLE (fitdistr)",
            fit.result$estimate["shape"], 1/fit.result$estimate["rate"]))
cat(sprintf("%-30s %-15.4f %-15.4f\n", "Method of Moments", mm.shape, mm.scale))

# Log-likelihood comparison
ll.true <- -loglike.gamma(c(true.shape, true.scale), sample.data)
ll.mle <- -result$value
ll.mm <- -loglike.gamma(c(mm.shape, mm.scale), sample.data)

cat(sprintf("\n%-30s %-15s\n", "Method", "Log-Likelihood"))
cat(paste(rep("-", 70), collapse=""), "\n")
cat(sprintf("%-30s %-15.4f\n", "True parameters", ll.true))
cat(sprintf("%-30s %-15.4f\n", "MLE", ll.mle))
cat(sprintf("%-30s %-15.4f\n", "Method of Moments", ll.mm))

cat("\nMLE maximizes log-likelihood\n")
