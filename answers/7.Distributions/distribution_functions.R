# Distribution Functions: d, p, q, r pattern
# Demonstrates the four types of distribution functions:
# - d: Density (PDF/PMF)
# - p: Probability (CDF)
# - q: Quantile (inverse CDF)
# - r: Random variates

# Example with Exponential Distribution
cat("=== Exponential Distribution Functions ===\n\n")

# Define range
x.range <- seq(0, 8, 0.05)

# 1. Density function (PDF)
cat("1. Density function (dexp):\n")
pdf.1 <- dexp(x.range, rate=1.0)
pdf.2 <- dexp(x.range, rate=0.5)
pdf.3 <- dexp(x.range, rate=0.2)
cat(sprintf("   PDF at x=1 with rate=1: %.4f\n", dexp(1, rate=1.0)))

# 2. Cumulative distribution function (CDF)
cat("\n2. Cumulative distribution function (pexp):\n")
cdf.1 <- pexp(x.range, rate=1.0)
cdf.2 <- pexp(x.range, rate=0.5)
cdf.3 <- pexp(x.range, rate=0.2)
cat(sprintf("   P(X < 1) with rate=1: %.4f\n", pexp(1, rate=1.0)))

# 3. Quantile function (inverse CDF)
cat("\n3. Quantile function (qexp):\n")
q.value <- qexp(0.5, rate=1.0)
cat(sprintf("   Median (50th percentile) with rate=1: %.4f\n", q.value))
cat(sprintf("   95th percentile with rate=1: %.4f\n", qexp(0.95, rate=1.0)))

# 4. Random variates
cat("\n4. Random variates (rexp):\n")
set.seed(42)
random.samples <- rexp(10, rate=1.0)
cat("   10 random samples:", random.samples, "\n")

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/distribution_functions_r.png',
    width=1200, height=1000, res=150)
par(mfrow=c(2,2))

# Plot 1: PDF
plot(x.range, pdf.1, type="l", col="blue", lwd=2,
     main="Exponential PDF (Density)", xlab="x", ylab="f(x)")
lines(x.range, pdf.2, col="red", lwd=2)
lines(x.range, pdf.3, col="green", lwd=2)
legend("topright", legend=c("rate=1.0", "rate=0.5", "rate=0.2"),
       col=c("blue", "red", "green"), lwd=2)
grid()

# Plot 2: CDF
plot(x.range, cdf.1, type="l", col="blue", lwd=2,
     main="Exponential CDF (Probability)", xlab="x", ylab="P(X < x)")
lines(x.range, cdf.2, col="red", lwd=2)
lines(x.range, cdf.3, col="green", lwd=2)
legend("bottomright", legend=c("rate=1.0", "rate=0.5", "rate=0.2"),
       col=c("blue", "red", "green"), lwd=2)
grid()

# Plot 3: Normal distribution examples
x.norm <- seq(-4, 4, 0.05)
plot(x.norm, dnorm(x.norm, 0, 1), type="l", col="blue", lwd=2,
     main="Normal Distribution PDF", xlab="x", ylab="f(x)")
lines(x.norm, dnorm(x.norm, 0, 0.5), col="red", lwd=2)
lines(x.norm, dnorm(x.norm, 1, 1), col="green", lwd=2)
legend("topright", legend=c("μ=0, σ=1", "μ=0, σ=0.5", "μ=1, σ=1"),
       col=c("blue", "red", "green"), lwd=2)
grid()

# Plot 4: Gamma distribution examples
x.gamma <- seq(0, 20, 0.1)
plot(x.gamma, dgamma(x.gamma, shape=2, scale=2), type="l", col="blue", lwd=2,
     main="Gamma Distribution PDF", xlab="x", ylab="f(x)")
lines(x.gamma, dgamma(x.gamma, shape=5, scale=1), col="red", lwd=2)
lines(x.gamma, dgamma(x.gamma, shape=1, scale=2), col="green", lwd=2)
legend("topright", legend=c("shape=2, scale=2", "shape=5, scale=1", "shape=1, scale=2"),
       col=c("blue", "red", "green"), lwd=2)
grid()

dev.off()
cat("\nVisualization saved as distribution_functions_r.png\n")

# Summary of common distributions
cat("\n=== Common Distributions in R ===\n")
cat("Continuous: norm, exp, gamma, beta, chisq, t, f, unif, lnorm, weibull\n")
cat("Discrete: binom, pois, nbinom, geom, hyper\n")
cat("\nAll support: d, p, q, r prefixes\n")
