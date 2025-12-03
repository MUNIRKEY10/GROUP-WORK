# Linear Congruential Generator (LCG) Implementation
# X_{n+1} = (a*X_n + c) mod m
# Demonstrates a simple pseudo-random number generator

# LCG function
lcg <- function(seed, a, c, m, n) {
  variates <- rep(NA, n)
  current <- seed

  for(i in 1:n) {
    current <- (a * current + c) %% m
    variates[i] <- current
  }

  return(variates)
}

# Example 1: Poor generator with short period (8)
cat("Poor LCG parameters (a=5, c=1, m=16):\n")
cat("Expected period: 8\n")
poor_sequence <- lcg(seed=10, a=5, c=1, m=16, n=20)
cat("Generated sequence:", poor_sequence, "\n")

# Example 2: Better generator with longer period
cat("\nBetter LCG parameters (a=1103515245, c=12345, m=2^31):\n")
better_sequence <- lcg(seed=10, a=1103515245, c=12345, m=2^31, n=20)
cat("Generated sequence (first 20):", better_sequence, "\n")

# Normalize to [0,1] and visualize
large_sequence <- lcg(seed=10, a=1103515245, c=12345, m=2^31, n=1000) / (2^31)

png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/lcg_visualization_r.png',
    width=1200, height=400, res=150)
par(mfrow=c(1,2))

hist(large_sequence, breaks=30, main='Distribution of LCG Values',
     xlab='Value', col='lightblue', border='black')

plot(large_sequence[1:100], type='o', pch=19, cex=0.5,
     main='First 100 LCG Values', xlab='Index', ylab='Value')

dev.off()
cat("\nVisualization saved as lcg_visualization_r.png\n")
