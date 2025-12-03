# Chi-Squared Tests
# Includes: Chi-squared test for association (contingency tables)
# and Chi-squared goodness-of-fit test for continuous distributions

cat("=== Chi-Squared Tests ===\n\n")

# Example 1: Chi-squared test for association (Contingency Table)
cat("--- Example 1: Test of Independence (Gender x Party Affiliation) ---\n\n")

# Create contingency table from the lesson
# Rows: Gender (Male, Female)
# Columns: Party (Democrat, Independent, Republican)
M <- matrix(c(762, 327, 468,
              484, 239, 477),
            nrow=2, ncol=3, byrow=TRUE)

rownames(M) <- c("Male", "Female")
colnames(M) <- c("Democrat", "Independent", "Republican")

cat("Contingency Table:\n")
print(M)
cat("\n")

# Perform chi-squared test
Xsq <- chisq.test(M)

cat(sprintf("Chi-squared statistic: %.4f\n", Xsq$statistic))
cat(sprintf("Degrees of freedom: %d\n", Xsq$parameter))
cat(sprintf("p-value: %.6e\n", Xsq$p.value))
cat("\n")

cat("Expected frequencies:\n")
print(Xsq$expected)
cat("\n")

if(Xsq$p.value < 0.05) {
  cat("Conclusion: Reject H0. Gender and party affiliation are associated (dependent).\n")
} else {
  cat("Conclusion: Cannot reject H0. Gender and party affiliation may be independent.\n")
}

# Example 2: Chi-squared goodness-of-fit test for continuous distribution
cat("\n")
cat(paste(rep("=", 70), collapse=""), "\n")
cat("--- Example 2: Goodness-of-Fit Test for Continuous Distribution ---\n\n")

# Generate sample data (simulating cat heart weight data)
set.seed(42)
cats.Hwt <- rgamma(144, shape=17.5, scale=0.607)

# Fit gamma distribution using method of moments
m <- mean(cats.Hwt)
v <- var(cats.Hwt)
fitted.shape <- m^2 / v
fitted.scale <- v / m

cat(sprintf("Sample size: %d\n", length(cats.Hwt)))
cat(sprintf("Fitted Gamma parameters: shape=%.4f, scale=%.4f\n\n", fitted.shape, fitted.scale))

# Create histogram (without plotting)
cats.hist <- hist(cats.Hwt, breaks=c(6, 8, 10, 12, 14, 16, 18, 20, 22), plot=FALSE)

cat("Histogram bins:", cats.hist$breaks, "\n")
cat("Observed counts:", cats.hist$counts, "\n")
cat(sprintf("Sum of counts: %d\n\n", sum(cats.hist$counts)))

# Calculate theoretical probabilities for each bin
# Use -Inf for first bin and Inf for last bin
p.edges <- c(-Inf, cats.hist$breaks[-c(1, length(cats.hist$breaks))], Inf)
theoretical.probs <- diff(pgamma(p.edges, shape=fitted.shape, scale=fitted.scale))

# Normalize probabilities
theoretical.probs <- theoretical.probs / sum(theoretical.probs)

cat("Theoretical probabilities:", theoretical.probs, "\n")
cat(sprintf("Sum of probabilities: %.6f\n\n", sum(theoretical.probs)))

# Expected counts
expected.counts <- theoretical.probs * length(cats.Hwt)
cat("Expected counts:", expected.counts, "\n")
cat(sprintf("Sum of expected: %.2f\n\n", sum(expected.counts)))

# Pad observed counts with zeros at beginning and end
observed.padded <- c(0, cats.hist$counts, 0)

# Perform chi-squared test
x2 <- chisq.test(observed.padded, p=theoretical.probs)

cat(sprintf("Chi-squared statistic: %.4f\n", x2$statistic))

# Adjust degrees of freedom for estimated parameters
# df = number of bins - 1 - number of estimated parameters
df.adjusted <- length(cats.hist$counts) + 2 - 2  # 2 parameters estimated
p.val.adjusted <- pchisq(x2$statistic, df=df.adjusted, lower.tail=FALSE)

cat(sprintf("Degrees of freedom (adjusted): %d\n", df.adjusted))
cat(sprintf("p-value (adjusted): %.4f\n\n", p.val.adjusted))

if(p.val.adjusted > 0.05) {
  cat("Conclusion: Cannot reject H0. Data is consistent with fitted Gamma distribution.\n")
} else {
  cat("Conclusion: Reject H0. Data may not follow fitted Gamma distribution.\n")
}

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/chi_squared_test_r.png',
    width=1400, height=500, res=150)
par(mfrow=c(1,2))

# Plot 1: Contingency table visualization
barplot(M, beside=TRUE, col=c("lightblue", "pink"),
        main="Gender x Party Affiliation",
        xlab="Party Affiliation", ylab="Count",
        legend=rownames(M), args.legend=list(x="topright"))
grid(NA, NULL)

# Plot 2: Observed vs Expected counts
bin.centers <- (cats.hist$breaks[-1] + cats.hist$breaks[-length(cats.hist$breaks)]) / 2
barplot(cats.hist$counts, names.arg=round(bin.centers, 1),
        col="lightblue", border="black",
        main="Chi-Squared Goodness-of-Fit Test",
        xlab="Heart Weight (g)", ylab="Frequency")
points(1:length(bin.centers), expected.counts[2:(length(expected.counts)-1)],
       col="red", pch=19, cex=1.5, type="o", lwd=2)
legend("topright", legend=c("Observed", "Expected (Gamma)"),
       col=c("lightblue", "red"), pch=c(15, 19), lwd=c(NA, 2))
grid(NA, NULL)

dev.off()
cat("\nVisualization saved as chi_squared_test_r.png\n")
