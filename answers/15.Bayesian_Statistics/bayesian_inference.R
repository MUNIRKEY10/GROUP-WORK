# Bayesian Inference in R

cat("=== Bayesian Inference ===\n\n")

# Example: Estimating coin flip probability
n.flips <- 10
n.heads <- 7

# Prior: Beta(2, 2)
alpha.prior <- 2
beta.prior <- 2

# Posterior: Beta(alpha.prior + n.heads, beta.prior + n.tails)
alpha.post <- alpha.prior + n.heads
beta.post <- beta.prior + (n.flips - n.heads)

cat(sprintf("Data: %d heads in %d flips\n", n.heads, n.flips))
cat(sprintf("Prior: Beta(%d, %d)\n", alpha.prior, beta.prior))
cat(sprintf("Posterior: Beta(%d, %d)\n", alpha.post, beta.post))
cat(sprintf("Posterior mean: %.3f\n\n", alpha.post/(alpha.post + beta.post)))

# Visualization
png('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/15.Bayesian_Statistics/bayesian_inference_r.png',
    width=1000, height=600, res=150)

p.vals <- seq(0, 1, length=200)
prior <- dbeta(p.vals, alpha.prior, beta.prior)
likelihood <- dbinom(n.heads, n.flips, p.vals)
likelihood.scaled <- likelihood / max(likelihood) * max(dbeta(p.vals, alpha.post, beta.post))
posterior <- dbeta(p.vals, alpha.post, beta.post)

plot(p.vals, prior, type="l", col="blue", lwd=2, lty=2,
     xlab="Probability of Heads", ylab="Density",
     main="Bayesian Updating", ylim=c(0, max(posterior)*1.1))
lines(p.vals, likelihood.scaled, col="green", lwd=2, lty=3)
lines(p.vals, posterior, col="red", lwd=2)
abline(v=n.heads/n.flips, col="gray", lty=2, lwd=2)

legend("topright", legend=c("Prior", "Likelihood (scaled)", "Posterior",
                             sprintf("MLE = %.2f", n.heads/n.flips)),
       col=c("blue", "green", "red", "gray"), lwd=2, lty=c(2,3,1,2))

dev.off()
cat("Visualization saved as bayesian_inference_r.png\n")
