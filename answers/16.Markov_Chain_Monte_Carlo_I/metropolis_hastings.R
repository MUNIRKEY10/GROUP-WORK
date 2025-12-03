# Metropolis-Hastings MCMC in R

cat("=== Metropolis-Hastings MCMC ===\n\n")
set.seed(42)

# Target distribution: mixture of normals
target.density <- function(x) {
  0.3*dnorm(x, -2, 0.8) + 0.7*dnorm(x, 3, 1.5)
}

# Metropolis-Hastings algorithm
metropolis.hastings <- function(target, n.iter, proposal.sd=1.0) {
  samples <- numeric(n.iter)
  x.current <- 0.0  # Initial value
  n.accepted <- 0

  for(i in 1:n.iter) {
    # Propose new value
    x.proposed <- x.current + rnorm(1, 0, proposal.sd)

    # Acceptance probability
    alpha <- min(1, target(x.proposed) / target(x.current))

    # Accept or reject
    if(runif(1) < alpha) {
      x.current <- x.proposed
      n.accepted <- n.accepted + 1
    }

    samples[i] <- x.current
  }

  acceptance.rate <- n.accepted / n.iter
  return(list(samples=samples, acceptance.rate=acceptance.rate))
}

# Run MCMC
n.iter <- 10000
result <- metropolis.hastings(target.density, n.iter)

cat(sprintf("Acceptance rate: %.3f\n", result$acceptance.rate))
cat(sprintf("Sample mean: %.3f\n", mean(result$samples[1001:n.iter])))  # Burn-in

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/16.Markov_Chain_Monte_Carlo_I/metropolis_hastings_r.png',
    width=1500, height=400, res=150)
par(mfrow=c(1,3))

# Trace plot
plot(result$samples[1:500], type="l", xlab="Iteration", ylab="Value",
     main="Trace Plot (first 500)")

# Histogram vs true density
hist(result$samples[1001:n.iter], breaks=50, probability=TRUE,
     col="lightblue", border="black", main="Samples vs Target",
     xlab="Value", ylab="Density")
x.range <- seq(-5, 8, length=200)
lines(x.range, sapply(x.range, target.density), col="red", lwd=2)

# Autocorrelation
acf(result$samples[1001:n.iter], main="Autocorrelation", lag.max=100)

dev.off()
cat("\nVisualization saved as metropolis_hastings_r.png\n")
