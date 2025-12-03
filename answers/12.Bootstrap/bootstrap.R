# Bootstrap Resampling in R
library(boot)

cat("=== Bootstrap Resampling ===\n\n")
set.seed(42)

# Generate data
n <- 50
data <- rnorm(n, mean=10, sd=3)

cat(sprintf("Sample size: %d\n", n))
cat(sprintf("Sample mean: %.4f\n", mean(data)))
cat(sprintf("Sample std: %.4f\n\n", sd(data)))

# Nonparametric Bootstrap
cat("--- Nonparametric Bootstrap ---\n")
n.bootstrap <- 10000

bootstrap.means <- replicate(n.bootstrap, {
  boot.sample <- sample(data, size=n, replace=TRUE)
  mean(boot.sample)
})

cat(sprintf("Bootstrap mean: %.4f\n", mean(bootstrap.means)))
cat(sprintf("Bootstrap SE: %.4f\n", sd(bootstrap.means)))
cat(sprintf("Theoretical SE: %.4f\n\n", sd(data)/sqrt(n)))

# 95% CI
ci.lower <- quantile(bootstrap.means, 0.025)
ci.upper <- quantile(bootstrap.means, 0.975)
cat(sprintf("95%% Bootstrap CI: [%.4f, %.4f]\n\n", ci.lower, ci.upper))

# Bootstrap for other statistics
cat("--- Bootstrap for Median and Std Dev ---\n")
bootstrap.medians <- replicate(n.bootstrap, median(sample(data, n, replace=TRUE)))
bootstrap.sds <- replicate(n.bootstrap, sd(sample(data, n, replace=TRUE)))

cat(sprintf("Median: %.4f, Bootstrap SE: %.4f\n", median(data), sd(bootstrap.medians)))
cat(sprintf("Std Dev: %.4f, Bootstrap SE: %.4f\n\n", sd(data), sd(bootstrap.sds)))

# Parametric Bootstrap
cat("--- Parametric Bootstrap ---\n")
fitted.mean <- mean(data)
fitted.sd <- sd(data)

parametric.means <- replicate(n.bootstrap, {
  param.sample <- rnorm(n, fitted.mean, fitted.sd)
  mean(param.sample)
})

cat(sprintf("Parametric bootstrap SE: %.4f\n", sd(parametric.means)))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/12.Bootstrap/bootstrap_r.png',
    width=1400, height=1000, res=150)
par(mfrow=c(2,2))

# Plot 1: Original data
hist(data, breaks=15, probability=TRUE, col="lightblue", border="black",
     main="Original Data", xlab="Value")
x.range <- seq(min(data), max(data), length=100)
lines(x.range, dnorm(x.range, fitted.mean, fitted.sd), col="red", lwd=2)
abline(v=mean(data), col="blue", lwd=2, lty=2)

# Plot 2: Bootstrap distribution of mean
hist(bootstrap.means, breaks=50, probability=TRUE, col="lightgreen", border="black",
     main="Bootstrap Distribution of Mean", xlab="Mean")
abline(v=mean(data), col="red", lwd=2, lty=2)
abline(v=ci.lower, col="green", lwd=2, lty=2)
abline(v=ci.upper, col="green", lwd=2, lty=2)

# Plot 3: Bootstrap distributions comparison
hist(bootstrap.medians, breaks=50, probability=TRUE, col=rgb(1,0,0,0.5),
     border="black", main="Mean vs Median", xlab="Value")
hist(bootstrap.means, breaks=50, probability=TRUE, col=rgb(0,0,1,0.5),
     add=TRUE, border="black")
legend("topright", legend=c("Median", "Mean"),
       fill=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)))

# Plot 4: Nonparametric vs Parametric
hist(bootstrap.means, breaks=50, probability=TRUE, col=rgb(0,0,1,0.5),
     border="black", main="Nonparametric vs Parametric", xlab="Mean")
hist(parametric.means, breaks=50, probability=TRUE, col=rgb(1,0,0,0.5),
     add=TRUE, border="black")
legend("topright", legend=c("Nonparametric", "Parametric"),
       fill=c(rgb(0,0,1,0.5), rgb(1,0,0,0.5)))

dev.off()
cat("\nVisualization saved as bootstrap_r.png\n")
