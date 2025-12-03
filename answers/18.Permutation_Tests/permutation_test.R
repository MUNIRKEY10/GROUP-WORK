# Permutation Tests in R

cat("=== Permutation Test ===\n\n")
set.seed(42)

# Generate two samples
group1 <- rnorm(30, mean=10, sd=2)
group2 <- rnorm(30, mean=11.5, sd=2)

# Observed test statistic (difference in means)
obs.diff <- mean(group1) - mean(group2)
cat(sprintf("Observed difference: %.4f\n\n", obs.diff))

# Permutation test
n.permutations <- 10000
perm.diffs <- numeric(n.permutations)
combined <- c(group1, group2)
n1 <- length(group1)

for(i in 1:n.permutations) {
  # Shuffle labels
  perm.idx <- sample(length(combined))
  perm.g1 <- combined[perm.idx[1:n1]]
  perm.g2 <- combined[perm.idx[(n1+1):length(combined)]]

  perm.diffs[i] <- mean(perm.g1) - mean(perm.g2)
}

# Calculate p-value (two-tailed)
p.value <- mean(abs(perm.diffs) >= abs(obs.diff))
cat(sprintf("Permutation p-value: %.4f\n\n", p.value))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/18.Permutation_Tests/permutation_test_r.png',
    width=1000, height=600, res=150)

hist(perm.diffs, breaks=50, probability=TRUE, col="lightblue", border="black",
     xlab="Difference in Means", ylab="Density",
     main=sprintf("Permutation Distribution (p-value = %.4f)", p.value))
abline(v=obs.diff, col="red", lwd=2, lty=2)
abline(v=-obs.diff, col="red", lwd=2, lty=2)
legend("topright", legend=sprintf("Observed diff = %.3f", obs.diff),
       col="red", lwd=2, lty=2)

dev.off()
cat("Visualization saved as permutation_test_r.png\n")
