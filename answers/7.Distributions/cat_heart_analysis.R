# Cat Heart Weight Analysis
# Practical example: Fitting gamma distribution to cat heart weight data
# Uses method of moments and maximum likelihood estimation

library(MASS)

# Load cat data from MASS package
data("cats", package="MASS")

cat("=== Cat Heart Weight Analysis ===\n\n")
cat(sprintf("Sample size: %d\n", nrow(cats)))
cat(sprintf("Mean heart weight: %.4f g\n", mean(cats$Hwt)))
cat(sprintf("SD heart weight: %.4f g\n", sd(cats$Hwt)))
cat(sprintf("Min: %.4f g, Max: %.4f g\n", min(cats$Hwt), max(cats$Hwt)))

# Create visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/cat_heart_analysis_r.png',
    width=1200, height=1000, res=150)
par(mfrow=c(2,2))

# Histogram
hist(cats$Hwt, breaks=15, xlab="Heart Weight (g)", main="Histogram of Cat Heart Weights",
     col="lightblue", border="black")
grid()

# Method of Moments estimation
cat("\n--- Method of Moments Estimation ---\n")
gamma.est_MM <- function(x) {
  m <- mean(x)
  v <- var(x)
  return(c(shape=m^2/v, scale=v/m))
}

mm.estimates <- gamma.est_MM(cats$Hwt)
cat(sprintf("Shape: %.4f\n", mm.estimates["shape"]))
cat(sprintf("Scale: %.4f\n", mm.estimates["scale"]))
cat(sprintf("Rate: %.4f\n", 1/mm.estimates["scale"]))

# Maximum Likelihood Estimation
cat("\n--- Maximum Likelihood Estimation ---\n")
mle.fit <- fitdistr(cats$Hwt, densfun="gamma")
cat(sprintf("Shape: %.4f\n", mle.fit$estimate["shape"]))
cat(sprintf("Rate: %.4f\n", mle.fit$estimate["rate"]))
cat(sprintf("Scale: %.4f\n", 1/mle.fit$estimate["rate"]))

# Compare with the lesson's result
cat("\n--- Lesson Results ---\n")
cat("Shape = 20.2998092, Rate = 1.9095724\n")

# Overlay fitted density on histogram
x.range <- seq(0, max(cats$Hwt)+2, 0.1)
hist(cats$Hwt, breaks=15, probability=TRUE, xlab="Heart Weight (g)",
     main="Fitted Gamma Distribution", col="lightblue", border="black")
lines(x.range, dgamma(x.range, shape=mm.estimates["shape"], scale=mm.estimates["scale"]),
      col="red", lwd=2)
lines(x.range, dgamma(x.range, shape=mle.fit$estimate["shape"], rate=mle.fit$estimate["rate"]),
      col="blue", lwd=2)
legend("topright", legend=c("MM fit", "MLE fit"), col=c("red", "blue"), lwd=2)
grid()

# QQ plot
qqplot(qgamma(ppoints(length(cats$Hwt)),
              shape=mm.estimates["shape"],
              scale=mm.estimates["scale"]),
       cats$Hwt,
       xlab="Theoretical Quantiles", ylab="Observed Quantiles",
       main="QQ Plot (Method of Moments)")
abline(0, 1, col="red", lwd=2, lty=2)
grid()

# Kernel density estimation
plot(density(cats$Hwt), lwd=2, main="Kernel Density vs. Fitted Distribution",
     xlab="Heart Weight (g)", ylab="Density")
lines(x.range, dgamma(x.range, shape=mm.estimates["shape"], scale=mm.estimates["scale"]),
      col="red", lwd=2, lty=2)
legend("topright", legend=c("Kernel Density", "Fitted Gamma"),
       col=c("black", "red"), lwd=2, lty=c(1, 2))
grid()

dev.off()
cat("\nVisualization saved as cat_heart_analysis_r.png\n")

# Goodness of fit test (Kolmogorov-Smirnov)
cat("\n--- Kolmogorov-Smirnov Test ---\n")
ks.result <- ks.test(cats$Hwt, "pgamma",
                     shape=mm.estimates["shape"],
                     scale=mm.estimates["scale"])
cat(sprintf("KS statistic: %.6f\n", ks.result$statistic))
cat(sprintf("p-value: %.4f\n", ks.result$p.value))
if(ks.result$p.value > 0.05) {
  cat("Conclusion: Cannot reject H0. Data is consistent with Gamma distribution.\n")
} else {
  cat("Conclusion: Reject H0. Data may not follow Gamma distribution.\n")
}
