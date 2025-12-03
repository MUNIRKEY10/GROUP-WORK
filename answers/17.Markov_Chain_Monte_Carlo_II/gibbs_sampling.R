# Gibbs Sampling in R

cat("=== Gibbs Sampling ===\n\n")
set.seed(42)

# Bivariate normal with correlation
rho <- 0.8
n.iterations <- 5000

# Gibbs sampler
samples <- matrix(0, nrow=n.iterations, ncol=2)
x <- 0
y <- 0

for(i in 1:n.iterations) {
  # Sample x | y
  x <- rnorm(1, rho * y, sqrt(1 - rho^2))
  # Sample y | x
  y <- rnorm(1, rho * x, sqrt(1 - rho^2))

  samples[i, ] <- c(x, y)
}

cat(sprintf("Sample correlation: %.3f\n", cor(samples[1001:n.iterations, 1],
                                               samples[1001:n.iterations, 2])))
cat(sprintf("True correlation: %.3f\n\n", rho))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/17.Markov_Chain_Monte_Carlo_II/gibbs_sampling_r.png',
    width=1200, height=500, res=150)
par(mfrow=c(1,2))

# Plot 1: Sampling path
plot(samples[1:500, 1], samples[1:500, 2], type="l", col="blue", lwd=0.5,
     xlab="X", ylab="Y", main="Gibbs Sampling Path (first 500)")
points(samples[1:500, 1], samples[1:500, 2], pch=20, cex=0.5,
       col=colorRampPalette(c("blue", "red"))(500))

# Plot 2: Samples after burn-in
plot(samples[1001:n.iterations, 1], samples[1001:n.iterations, 2],
     pch=20, cex=0.3, col=rgb(0,0,1,0.3),
     xlab="X", ylab="Y", main="Samples (after burn-in)")

dev.off()
cat("Visualization saved as gibbs_sampling_r.png\n")
