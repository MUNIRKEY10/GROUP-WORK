# R code for "Distributions"

library(MASS) # For fitdistr, cats dataset

# --- Random Number Generation ---
# Example: runif()
set.seed(10)
print(runif(10))
set.seed(10)
print(runif(10))

# Linear Congruential Generator (LCG)
# Using a mutable global variable 'seed' for demonstration
seed <- 10
new.random <- function (a = 5, c = 12, m = 16) {
  out <- (a * seed + c) %% m
  seed <<- out # Use <<- to assign to global 'seed'
  return(out)
}

# Test LCG with period 8
out.length <- 20
variates_lcg1 <- rep(NA, out.length)
for (kk in 1:out.length) variates_lcg1[kk] <- new.random(a = 5, c = 12, m = 16) # Reset seed for each run if testing different params
print(variates_lcg1)

seed <- 10 # Reset seed
variates_lcg2 <- rep(NA, out.length)
for (kk in 1:out.length) variates_lcg2[kk] <- new.random(a = 131, c = 7, m = 16)
print(variates_lcg2)

seed <- 10 # Reset seed
variates_lcg3 <- rep(NA, out.length)
for (kk in 1:out.length) variates_lcg3[kk] <- new.random(a = 129, c = 7, m = 16)
print(variates_lcg3)

seed <- 10 # Reset seed
variates_lcg4 <- rep(NA, out.length)
for (kk in 1:out.length) variates_lcg4[kk] <- new.random(a = 1664545, c = 1013904223, m = 2^32)
print(variates_lcg4)

# --- Distributions in R (d, p, q, r functions) ---
# Exponential distribution: density (dexp) and CDF (pexp)
this.range <- seq(0, 8, .05)
pdf("exponential_pdf.pdf", width=7, height=5)
plot(this.range, dexp(this.range), type = "l", main = "Exponential Distributions (PDF)",
      xlab = "x", ylab = "f(x)", col = "black", ylim = c(0, 1))
lines(this.range, dexp(this.range, rate = 0.5), col = "red")
lines(this.range, dexp(this.range, rate = 0.2), col = "blue")
legend("topright", legend = c("rate=1", "rate=0.5", "rate=0.2"), col = c("black", "red", "blue"), lty = 1)
dev.off()

pdf("exponential_cdf.pdf", width=7, height=5)
plot(this.range, pexp(this.range), type = "l", main = "Exponential Distributions (CDF)",
      xlab = "x", ylab = "P(X<x)", col = "black", ylim = c(0, 1))
lines(this.range, pexp(this.range, rate = 0.5), col = "red")
lines(this.range, pexp(this.range, rate = 0.2), col = "blue")
legend("bottomright", legend = c("rate=1", "rate=0.5", "rate=0.2"), col = c("black", "red", "blue"), lty = 1)
dev.off()

# --- Fitting Distributional Models ---
# Method of Moments: Closed form (Gamma Distribution Example)
gamma.est_MM <- function(x) {
  m <- mean(x); v <- var(x)
  return(c(shape = m^2 / v, scale = v / m))
}

# Method of Moments: Numerically (Discrepancy function)
gamma.mean <- function(shape, scale) { return(shape * scale) }
gamma.var <- function(shape, scale) { return(shape * scale^2) }
gamma.discrepancy <- function(shape, scale, x) {
  return((mean(x) - gamma.mean(shape, scale))^2 + (var(x) - gamma.var(shape, scale))^2)
}

# --- Maximum Likelihood Estimation ---
# Example: Cat heart weights from MASS package
data("cats", package = "MASS")

pdf("cats_hwt_hist.pdf", width=7, height=5)
hist(cats$Hwt, xlab = "Heart Weight", main = "Histogram of Cat Heart Weights")
dev.off()

# Using fitdistr for MLE
cats.mle_gamma <- fitdistr(cats$Hwt, densfun = "gamma")
print(cats.mle_gamma)

# Using Method of Moments estimates for comparison
cats.gamma_mm <- gamma.est_MM(cats$Hwt)
print(cats.gamma_mm)

# Checking the fit: QQ Plot
pdf("cats_hwt_qqplot_gamma.pdf", width=7, height=5)
qqplot(cats$Hwt, qgamma(ppoints(500), shape = cats.gamma_mm["shape"], scale = cats.gamma_mm["scale"]),
      xlab = "Observed Heart Weight", ylab = "Theoretical Gamma Quantiles",
      main = "QQ Plot: Cat Heart Weights vs. Gamma (MM)")
abline(0, 1, col = "red")
dev.off()

pdf("cats_hwt_qqplot_gamma_mle.pdf", width=7, height=5)
qqplot(cats$Hwt, qgamma(ppoints(500), shape = cats.mle_gamma$estimate["shape"], rate = cats.mle_gamma$estimate["rate"]),
      xlab = "Observed Heart Weight", ylab = "Theoretical Gamma Quantiles",
      main = "QQ Plot: Cat Heart Weights vs. Gamma (MLE)")
abline(0, 1, col = "blue")
dev.off()

# Checking the fit: Density plot overlay
pdf("cats_hwt_density_gamma.pdf", width=7, height=5)
plot(density(cats$Hwt), main = "Density of Cat Heart Weights with Gamma Fit", xlab = "Heart Weight")
curve(dgamma(x, shape = cats.gamma_mm["shape"], scale = cats.gamma_mm["scale"]), add = TRUE, col = "red", lty = 2)
curve(dgamma(x, shape = cats.mle_gamma$estimate["shape"], rate = cats.mle_gamma$estimate["rate"]), add = TRUE, col = "blue", lty = 1)
legend("topright", legend = c("Empirical Density", "Gamma (MM)", "Gamma (MLE)"),
       col = c("black", "red", "blue"), lty = c(1, 2, 1))
dev.off()

# Checking the fit: Calibration plots
pdf("cats_hwt_calibration_gamma_mm.pdf", width=7, height=5)
plot(ecdf(pgamma(cats$Hwt, shape = cats.gamma_mm["shape"], scale = cats.gamma_mm["scale"])),
     main = "Calibration Plot for Cat Heart Weights (MM)", verticals = T, pch = "")
abline(0, 1, col = "grey")
dev.off()

pdf("cats_hwt_calibration_gamma_mle.pdf", width=7, height=5)
plot(ecdf(pgamma(cats$Hwt, shape = cats.mle_gamma$estimate["shape"], rate = cats.mle_gamma$estimate["rate"])),
     main = "Calibration Plot for Cat Heart Weights (MLE)", verticals = T, pch = "")
abline(0, 1, col = "darkgreen")
dev.off()

# --- Kolmogorov-Smirnov test ---
# One-sample KS test
# Note: R throws a warning about ties, but proceeds. The p-value is approximate.
ks_test_one_sample <- ks.test(cats$Hwt, pgamma, shape = cats.gamma_mm["shape"], scale = cats.gamma_mm["scale"])
print(ks_test_one_sample)

# Two-sample KS test
set.seed(42)
x_norm <- rnorm(100, mean = 0, sd = 1)
y_norm <- rnorm(100, mean = 0.5, sd = 1)
ks_test_two_sample <- ks.test(x_norm, y_norm)
print(ks_test_two_sample)

# --- Chi-squared test ---
# Chi-squared test for categorical data
M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("F", "M"), party = c("Democrat", "Independent", "Republican"))
print(M)
Xsq_categorical <- chisq.test(M)
print(Xsq_categorical)

# Chi-squared test for continuous distributions
cats.hist <- hist(cats$Hwt, plot = FALSE)
print(cats.hist$breaks)
print(cats.hist$counts)

# Calculate theoretical probabilities for bins using MLE parameters
# Padding with -Inf and Inf for correct probability calculation for boundary bins
p_theoretical <- diff(pgamma(c(-Inf, cats.hist$breaks, Inf),
                             shape = cats.mle_gamma$estimate["shape"],
                             rate = cats.mle_gamma$estimate["rate"])) # Note rate is used for gamma in R, not scale with fitdistr

# We need to ensure that the sum of p_theoretical is 1, and handle cases where counts might be zero.
# chisq.test expects all counts to be positive, so we adjust counts and probabilities to remove 0-count bins for the test if necessary

# Filter out bins with zero expected probability if any (very small values might cause issues too)
# For simplicity, let's assume no zero-probability bins for now given the continuous distribution.
# Also, chisq.test requires that sum(p) == 1. So, normalize p_theoretical.
p_theoretical <- p_theoretical / sum(p_theoretical)

# R's chisq.test can handle some 0 counts in observed if expected are not too small
# However, the example code uses c(0, cats.hist$counts, 0) which implies adding two more bins that might not correspond to the actual breaks.
# Let's adjust to match the bins explicitly.
# Number of bins = length(counts)
observed_counts <- cats.hist$counts
# Remove any bins with 0 counts *and* very low theoretical probability to avoid chi-sq approx warnings on small expected counts
# This is a heuristic and can be refined.
valid_bins = (observed_counts > 0) | (p_theoretical * sum(observed_counts) > 5) # Expected count > 5 is a common rule of thumb

adjusted_observed_counts = observed_counts[valid_bins]
adjusted_p_theoretical = p_theoretical[valid_bins]
adjusted_p_theoretical = adjusted_p_theoretical / sum(adjusted_p_theoretical) # Re-normalize

# If after adjustment, we have fewer than 2 bins, chisq.test might fail.
if (length(adjusted_observed_counts) > 1) {
    Xsq_continuous <- chisq.test(adjusted_observed_counts, p = adjusted_p_theoretical, rescale.p = TRUE)
    # df adjustment: df = (number of bins - 1) - number of estimated parameters
    # Number of estimated parameters for Gamma is 2 (shape and rate/scale)
    adjusted_df = length(adjusted_observed_counts) - 1 - 2
    if (adjusted_df > 0) {
        p_value_continuous <- 1 - pchisq(Xsq_continuous$statistic, df = adjusted_df)
        print(paste("Chi-squared statistic (adjusted df):", Xsq_continuous$statistic))
        print(paste("Adjusted p-value:", p_value_continuous))
    } else {
        print("Adjusted degrees of freedom is not positive, cannot calculate p-value.")
        print(Xsq_continuous) # Print original test result for inspection
    }
} else {
    print("Not enough valid bins for Chi-squared test after adjustment.")
}

