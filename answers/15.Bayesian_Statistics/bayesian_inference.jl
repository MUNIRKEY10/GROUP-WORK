# Bayesian Inference in Julia
using Distributions, Plots

println("=== Bayesian Inference ===\n")

# Example: Estimating coin flip probability
n_flips, n_heads = 10, 7

# Prior: Beta(2, 2)
α_prior, β_prior = 2, 2

# Posterior: Beta(α_prior + n_heads, β_prior + n_tails)
α_post = α_prior + n_heads
β_post = β_prior + (n_flips - n_heads)

println("Data: $n_heads heads in $n_flips flips")
println("Prior: Beta($α_prior, $β_prior)")
println("Posterior: Beta($α_post, $β_post)")
println("Posterior mean: $(round(α_post/(α_post + β_post), digits=3))\n")

# Visualization
p_vals = 0:0.005:1
prior = pdf.(Beta(α_prior, β_prior), p_vals)
likelihood = pdf.(Binomial(n_flips, p_vals), n_heads)
likelihood_scaled = likelihood ./ maximum(likelihood) .* maximum(pdf.(Beta(α_post, β_post), p_vals))
posterior = pdf.(Beta(α_post, β_post), p_vals)

plot(p_vals, prior, label="Prior", linewidth=2, linestyle=:dash, color=:blue)
plot!(p_vals, likelihood_scaled, label="Likelihood (scaled)", linewidth=2, linestyle=:dot, color=:green)
plot!(p_vals, posterior, label="Posterior", linewidth=2, color=:red)
vline!([n_heads/n_flips], label="MLE = $(n_heads/n_flips)", linewidth=2, linestyle=:dash, color=:gray)
xlabel!("Probability of Heads")
ylabel!("Density")
title!("Bayesian Updating")

savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/15.Bayesian_Statistics/bayesian_inference_jl.png")
println("Visualization saved")
