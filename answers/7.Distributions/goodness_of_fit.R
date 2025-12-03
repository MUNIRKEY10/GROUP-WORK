# Goodness of Fit Tests
# Includes: QQ plots, Calibration plots, and Kolmogorov-Smirnov test

# Generate sample data
set.seed(42)
sample.data <- rgamma(100, shape=5, scale=2)

# Fit gamma distribution using method of moments
m <- mean(sample.data)
v <- var(sample.data)
fitted.shape <- m^2 / v
fitted.scale <- v / m

cat("=== Goodness of Fit Tests ===\n\n")
cat(sprintf("Sample size: %d\n", length(sample.data)))
cat(sprintf("Fitted parameters: shape=%.4f, scale=%.4f\n", fitted.shape, fitted.scale))

# Create visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/goodness_of_fit_r.png',
    width=1200, height=1000, res=150)
par(mfrow=c(2,2))

# 1. QQ Plot
cat("\n--- QQ Plot ---\n")
cat("Compares sample quantiles to theoretical quantiles\n")

qqplot(qgamma(ppoints(length(sample.data)), shape=fitted.shape, scale=fitted.scale),
       sample.data,
       xlab="Theoretical Quantiles", ylab="Observed Quantiles",
       main="QQ Plot", pch=19, col=rgb(0,0,1,0.6))
abline(0, 1, col="red", lwd=2, lty=2)
grid()

# 2. Calibration Plot
cat("\n--- Calibration Plot ---\n")
cat("Shows empirical CDF of theoretical CDF values\n")
cat("Should follow diagonal if distribution fits well\n")

# Transform data using fitted CDF
cdf.values <- pgamma(sample.data, shape=fitted.shape, scale=fitted.scale)

# Plot empirical CDF of these values
plot(ecdf(cdf.values), verticals=TRUE, pch="",
     main="Calibration Plot",
     xlab="Theoretical CDF", ylab="Empirical CDF")
abline(0, 1, col="grey", lwd=2, lty=2)
grid()

# 3. Kolmogorov-Smirnov Test
cat("\n--- Kolmogorov-Smirnov Test (One-sample) ---\n")
ks.result <- ks.test(sample.data, "pgamma", shape=fitted.shape, scale=fitted.scale)
cat(sprintf("KS statistic (D): %.6f\n", ks.result$statistic))
cat(sprintf("p-value: %.4f\n", ks.result$p.value))

if(ks.result$p.value > 0.05) {
  cat("Conclusion: Cannot reject H0. Data is consistent with fitted distribution.\n")
} else {
  cat("Conclusion: Reject H0. Data may not follow fitted distribution.\n")
}

# Visualize KS test
x.sorted <- sort(sample.data)
theoretical.cdf <- pgamma(x.sorted, shape=fitted.shape, scale=fitted.scale)
n <- length(x.sorted)
empirical.cdf <- (1:n) / n

plot(x.sorted, empirical.cdf, type="s", lwd=2, col="blue",
     main="Kolmogorov-Smirnov Test Visualization",
     xlab="Value", ylab="Cumulative Probability")
lines(x.sorted, theoretical.cdf, col="red", lwd=2)

# Show maximum difference
max.diff.idx <- which.max(abs(empirical.cdf - theoretical.cdf))
segments(x.sorted[max.diff.idx], empirical.cdf[max.diff.idx],
         x.sorted[max.diff.idx], theoretical.cdf[max.diff.idx],
         col="green", lwd=2)
legend("bottomright", legend=c("Empirical CDF", "Theoretical CDF",
                                sprintf("Max diff (D=%.3f)", ks.result$statistic)),
       col=c("blue", "red", "green"), lwd=2)
grid()

# 4. Two-sample KS Test
cat("\n--- Kolmogorov-Smirnov Test (Two-sample) ---\n")
cat("Comparing two samples from different distributions\n")

# Generate two samples
set.seed(42)
sample1 <- rnorm(100, mean=0, sd=1)
sample2 <- rnorm(100, mean=0.5, sd=1)

ks.2sample <- ks.test(sample1, sample2)
cat("Sample 1: N(0, 1), n=100\n")
cat("Sample 2: N(0.5, 1), n=100\n")
cat(sprintf("KS statistic (D): %.6f\n", ks.2sample$statistic))
cat(sprintf("p-value: %.4f\n", ks.2sample$p.value))

if(ks.2sample$p.value < 0.05) {
  cat("Conclusion: Reject H0. Samples come from different distributions.\n")
} else {
  cat("Conclusion: Cannot reject H0. Samples may come from same distribution.\n")
}

# Visualize two-sample comparison
plot(ecdf(sample1), verticals=TRUE, do.points=FALSE, col="blue", lwd=2,
     main="Two-Sample KS Test", xlab="Value", ylab="Cumulative Probability")
plot(ecdf(sample2), verticals=TRUE, do.points=FALSE, col="red", lwd=2, add=TRUE)
legend("topleft", legend=c("Sample 1", "Sample 2"),
       col=c("blue", "red"), lwd=2)
grid()

dev.off()
cat("\nVisualization saved as goodness_of_fit_r.png\n")
