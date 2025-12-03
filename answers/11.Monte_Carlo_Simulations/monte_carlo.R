# Monte Carlo Simulation in R
# Using simulation to estimate expectations and perform integration

cat("=== Monte Carlo Simulation ===\n\n")

# Set seed
set.seed(42)

# Key Concept 1: Estimating Expectations using LLN
cat("--- Example 1: Estimating E[X] for Normal Distribution ---\n")
cat("True E[X] = μ = 5\n\n")

mu <- 5
sigma <- 2
sample.sizes <- c(10, 100, 1000, 10000)

cat(sprintf("%-15s %-20s %-15s\n", "Sample Size", "Estimated E[X]", "Error"))
cat(paste(rep("-", 50), collapse=""), "\n")

for(n in sample.sizes) {
  samples <- rnorm(n, mu, sigma)
  estimate <- mean(samples)
  error <- abs(estimate - mu)
  cat(sprintf("%-15d %-20.6f %-15.6e\n", n, estimate, error))
}

# Example 2: Monte Carlo Integration
cat("\n--- Example 2: Monte Carlo Integration ---\n")
cat("Estimate ∫₀¹ x² dx = 1/3 ≈ 0.333333\n\n")

f <- function(x) x^2

n.samples <- 100000
x.samples <- runif(n.samples, 0, 1)
f.samples <- f(x.samples)
mc.estimate <- mean(f.samples) * (1 - 0)  # * (b - a)

cat(sprintf("True value: %.6f\n", 1/3))
cat(sprintf("Monte Carlo estimate (n=%d): %.6f\n", n.samples, mc.estimate))
cat(sprintf("Error: %.6e\n\n", abs(mc.estimate - 1/3)))

# Example 3: Estimating π using Monte Carlo
cat("--- Example 3: Estimating π ---\n")
cat("Sample points uniformly in [0,1]×[0,1] square\n")
cat("Count how many fall inside quarter circle\n\n")

n.points <- 100000
x <- runif(n.points, 0, 1)
y <- runif(n.points, 0, 1)

inside.circle <- (x^2 + y^2) <= 1
pi.estimate <- 4 * sum(inside.circle) / n.points

cat(sprintf("True π: %.6f\n", pi))
cat(sprintf("Monte Carlo estimate (n=%d): %.6f\n", n.points, pi.estimate))
cat(sprintf("Error: %.6e\n\n", abs(pi.estimate - pi)))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/11.Monte_Carlo_Simulations/monte_carlo_r.png',
    width=1400, height=1000, res=150)
par(mfrow=c(2,2))

# Plot 1: Convergence
max.n <- 10000
samples.conv <- rnorm(max.n, mu, sigma)
cumulative.means <- cumsum(samples.conv) / (1:max.n)

plot(1:max.n, cumulative.means, type="l", col="blue", log="x",
     xlab="Sample Size", ylab="Estimated Mean",
     main="Convergence of Monte Carlo Estimate")
abline(h=mu, col="red", lwd=2, lty=2)
legend("topright", legend=c("Estimate", sprintf("True mean = %d", mu)),
       col=c("blue", "red"), lwd=2, lty=c(1, 2))

# Plot 2: Integration
x.plot <- seq(0, 1, length=1000)
plot(x.plot, f(x.plot), type="l", lwd=2, col="blue",
     xlab="x", ylab="f(x)", main="Monte Carlo Integration: ∫₀¹ x² dx")
polygon(c(0, x.plot, 1), c(0, f(x.plot), 0), col=rgb(0,0,1,0.3), border=NA)
text(0.5, 0.5, sprintf("MC estimate: %.4f\nTrue value: %.4f", mc.estimate, 1/3),
     adj=c(0.5, 0.5))

# Plot 3: π estimation
plot(x[inside.circle][1:1000], y[inside.circle][1:1000],
     pch=20, cex=0.3, col="blue", xlim=c(0,1), ylim=c(0,1),
     xlab="x", ylab="y", main=sprintf("Estimating π: %.4f", pi.estimate),
     asp=1)
points(x[!inside.circle][1:1000], y[!inside.circle][1:1000],
       pch=20, cex=0.3, col="red")
theta <- seq(0, pi/2, length=100)
lines(cos(theta), sin(theta), lwd=2)

# Plot 4: Distribution of sample means (CLT)
n.experiments <- 1000
sample.size <- 30
sample.means <- replicate(n.experiments, mean(rnorm(sample.size, mu, sigma)))

hist(sample.means, breaks=30, probability=TRUE, col="lightblue",
     border="black", main="Distribution of Sample Means (CLT)",
     xlab="Sample Mean", ylab="Density")
x.range <- seq(min(sample.means), max(sample.means), length=100)
lines(x.range, dnorm(x.range, mu, sigma/sqrt(sample.size)),
      col="red", lwd=2)
legend("topright", legend=c("Empirical", "Theoretical"),
       col=c("lightblue", "red"), lwd=2)

dev.off()
cat("Visualization saved as monte_carlo_r.png\n")
