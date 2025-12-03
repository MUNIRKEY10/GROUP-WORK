# Distribution Simulation in R
# Simulating random variables from various probability distributions

cat("=== Distribution Simulation ===\n\n")

# Set seed for reproducibility
set.seed(42)

# Key Concept: Four types of distribution functions
cat("--- Four Distribution Functions ---\n")
cat("1. pdf/pmf (d): Probability density/mass function\n")
cat("2. cdf (p): Cumulative distribution function\n")
cat("3. quantile (q): Inverse CDF (percentile)\n")
cat("4. random (r): Generate random samples\n\n")

# Example with Normal distribution
cat("Example: Normal Distribution N(μ=5, σ=2)\n")
mu <- 5
sigma <- 2
x <- 6

cat(sprintf("\n1. PDF at x=%d: %.6f\n", x, dnorm(x, mu, sigma)))
cat(sprintf("2. CDF P(X ≤ %d): %.6f\n", x, pnorm(x, mu, sigma)))
cat(sprintf("3. 95th percentile: %.6f\n", qnorm(0.95, mu, sigma)))
cat(sprintf("4. Random sample (n=5): %s\n", paste(round(rnorm(5, mu, sigma), 3), collapse=", ")))

# Common distributions and their simulation
cat("\n--- Simulating Common Distributions ---\n\n")

n.samples <- 1000

# 1. Normal
normal.samples <- rnorm(n.samples, mu, sigma)
cat(sprintf("1. Normal(5, 2): mean=%.3f, sd=%.3f\n", mean(normal.samples), sd(normal.samples)))

# 2. Exponential
exp.samples <- rexp(n.samples, rate=0.5)
cat(sprintf("2. Exponential(λ=0.5): mean=%.3f\n", mean(exp.samples)))

# 3. Binomial
binom.samples <- rbinom(n.samples, size=10, prob=0.3)
cat(sprintf("3. Binomial(n=10, p=0.3): mean=%.3f\n", mean(binom.samples)))

# 4. Poisson
poisson.samples <- rpois(n.samples, lambda=4.5)
cat(sprintf("4. Poisson(λ=4.5): mean=%.3f\n", mean(poisson.samples)))

# 5. Uniform
uniform.samples <- runif(n.samples, 0, 1)
cat(sprintf("5. Uniform(0, 1): mean=%.3f\n", mean(uniform.samples)))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/10.Simulation/distribution_simulation_r.png',
    width=1500, height=1000, res=150)
par(mfrow=c(2,3))

# Plot 1: Normal
hist(normal.samples, breaks=30, probability=TRUE, main="Normal(5, 2)",
     xlab="Value", col="lightblue", border="black")
x.range <- seq(min(normal.samples), max(normal.samples), length=100)
lines(x.range, dnorm(x.range, mu, sigma), col="red", lwd=2)

# Plot 2: Exponential
hist(exp.samples, breaks=30, probability=TRUE, main="Exponential(λ=0.5)",
     xlab="Value", col="lightgreen", border="black")
x.range <- seq(0, max(exp.samples), length=100)
lines(x.range, dexp(x.range, rate=0.5), col="red", lwd=2)

# Plot 3: Binomial
hist(binom.samples, breaks=0:11-0.5, probability=TRUE, main="Binomial(n=10, p=0.3)",
     xlab="Value", col="lightcoral", border="black")
x.vals <- 0:10
lines(x.vals, dbinom(x.vals, 10, 0.3), type="o", col="red", lwd=2, pch=19)

# Plot 4: Poisson
hist(poisson.samples, breaks=(-1:15)+0.5, probability=TRUE, main="Poisson(λ=4.5)",
     xlab="Value", col="lightyellow", border="black")
x.vals <- 0:14
lines(x.vals, dpois(x.vals, 4.5), type="o", col="red", lwd=2, pch=19)

# Plot 5: Uniform
hist(uniform.samples, breaks=30, probability=TRUE, main="Uniform(0, 1)",
     xlab="Value", col="lightpink", border="black", ylim=c(0, 1.5))
abline(h=1, col="red", lwd=2)

# Plot 6: Q-Q plot
qqnorm(normal.samples, main="Q-Q Plot (Normal samples)")
qqline(normal.samples, col="red", lwd=2, lty=2)

dev.off()
cat("\nVisualization saved as distribution_simulation_r.png\n")
