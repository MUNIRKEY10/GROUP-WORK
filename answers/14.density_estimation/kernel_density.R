# Kernel Density Estimation in R

cat("=== Kernel Density Estimation ===\n\n")
set.seed(42)

# Generate data (bimodal)
data <- c(rnorm(100, 0, 1), rnorm(100, 5, 1.5))

# KDE using density()
kde.default <- density(data)
kde.small.bw <- density(data, bw=0.5)
kde.large.bw <- density(data, bw=2.0)

cat("Bandwidth selection:\n")
cat(sprintf("Default (Scott): %.4f\n", kde.default$bw))
cat(sprintf("Small bandwidth: 0.5\n"))
cat(sprintf("Large bandwidth: 2.0\n\n"))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/14.density_estimation/kernel_density_r.png',
    width=1400, height=500, res=150)
par(mfrow=c(1,2))

# Plot 1: Data histogram with KDE
hist(data, breaks=30, probability=TRUE, col="lightgray", border="black",
     main="Kernel Density Estimation", xlab="Value", ylab="Density")
lines(kde.default, col="red", lwd=2)
legend("topright", legend=c("Data", "KDE"), fill=c("lightgray", NA),
       border=c("black", NA), lty=c(NA, 1), col=c(NA, "red"), lwd=c(NA, 2))

# Plot 2: Effect of bandwidth
plot(kde.small.bw, col="blue", lwd=2, main="Effect of Bandwidth",
     xlab="Value", ylab="Density", ylim=c(0, max(kde.small.bw$y)))
lines(kde.default, col="red", lwd=2)
lines(kde.large.bw, col="green", lwd=2)
legend("topright", legend=c("h=0.5", sprintf("h=%.2f (default)", kde.default$bw), "h=2.0"),
       col=c("blue", "red", "green"), lwd=2)

dev.off()
cat("Visualization saved as kernel_density_r.png\n")
