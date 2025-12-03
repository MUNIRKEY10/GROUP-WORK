# Exercise: General Calibration Plot Function
# Creates a calibration plot that inputs a data vector, cumulative probability function,
# and parameter vector

calibration.plot <- function(data, p_foo, params, main="Calibration Plot",
                             xlab="Theoretical CDF", ylab="Empirical CDF",
                             add.diagonal=TRUE) {
  #' Create a calibration plot for goodness of fit assessment
  #'
  #' @param data Numeric vector of observed data
  #' @param p_foo Cumulative distribution function (e.g., pgamma, pnorm)
  #' @param params Named vector or list of parameters for p_foo
  #' @param main Plot title
  #' @param xlab X-axis label
  #' @param ylab Y-axis label
  #' @param add.diagonal Whether to add diagonal reference line
  #'
  #' @return Invisible NULL (creates plot as side effect)

  # Transform data using CDF
  cdf.values <- do.call(p_foo, c(list(q=data), as.list(params)))

  # Calculate and plot empirical CDF of transformed values
  plot(ecdf(cdf.values), verticals=TRUE, pch="",
       main=main, xlab=xlab, ylab=ylab,
       xlim=c(0,1), ylim=c(0,1))

  # Add diagonal reference line
  if(add.diagonal) {
    abline(0, 1, col="grey", lwd=2, lty=2)
  }

  grid()
  invisible(NULL)
}


# Example usage and demonstration
cat("=== Calibration Plot Function Demonstration ===\n\n")

# Generate sample data
set.seed(42)

# Example 1: Well-fitted distribution
cat("Example 1: Gamma data fitted with Gamma distribution\n")
gamma.data <- rgamma(200, shape=5, scale=2)
m <- mean(gamma.data)
v <- var(gamma.data)
fitted.shape <- m^2 / v
fitted.scale <- v / m

cat(sprintf("True parameters: shape=5, scale=2\n"))
cat(sprintf("Fitted parameters: shape=%.4f, scale=%.4f\n\n", fitted.shape, fitted.scale))

# Example 2: Poorly-fitted distribution
cat("Example 2: Normal data fitted with Gamma distribution (poor fit)\n")
normal.data <- rnorm(200, mean=10, sd=2)
# Force-fit gamma distribution
m2 <- mean(normal.data)
v2 <- var(normal.data)
forced.shape <- m2^2 / v2
forced.scale <- v2 / m2
cat(sprintf("Forced Gamma fit: shape=%.4f, scale=%.4f\n\n", forced.shape, forced.scale))

# Example 3: Exponential distribution
cat("Example 3: Exponential data fitted with Exponential distribution\n")
exp.data <- rexp(200, rate=0.5)  # scale = 2
fitted.scale.exp <- mean(exp.data)
cat(sprintf("True scale: 2.0\n"))
cat(sprintf("Fitted scale: %.4f\n\n", fitted.scale.exp))

# Create comparison plot
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/calibration_plot_function_r.png',
    width=1500, height=500, res=150)
par(mfrow=c(1,3))

# Plot 1: Good fit (Gamma-Gamma)
calibration.plot(gamma.data, pgamma,
                 params=list(shape=fitted.shape, scale=fitted.scale),
                 main="Good Fit: Gamma-Gamma")

# Plot 2: Poor fit (Normal-Gamma)
calibration.plot(normal.data, pgamma,
                 params=list(shape=forced.shape, scale=forced.scale),
                 main="Poor Fit: Normal-Gamma")

# Plot 3: Good fit (Exponential-Exponential)
calibration.plot(exp.data, pexp,
                 params=list(rate=1/fitted.scale.exp),
                 main="Good Fit: Exponential-Exponential")

dev.off()
cat("Visualization saved as calibration_plot_function_r.png\n")

# Additional example: Using with different distributions
cat("\n=== Additional Examples ===\n\n")

# Example with Normal distribution
cat("Example with Normal distribution:\n")
norm.data <- rnorm(100, mean=5, sd=2)
fitted.mean <- mean(norm.data)
fitted.sd <- sd(norm.data)

png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/calibration_example_normal.png',
    width=800, height=800, res=150)
calibration.plot(norm.data, pnorm,
                 params=list(mean=fitted.mean, sd=fitted.sd),
                 main="Normal Distribution Calibration")
dev.off()
cat("Normal calibration plot saved\n")
