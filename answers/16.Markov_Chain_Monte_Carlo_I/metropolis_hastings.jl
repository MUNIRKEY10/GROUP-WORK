# Metropolis-Hastings MCMC in Julia
using Distributions, Random, Plots, StatsBase

println("=== Metropolis-Hastings MCMC ===\n")
Random.seed!(42)

# Target distribution: mixture of normals
target_density(x) = 0.3*pdf(Normal(-2, 0.8), x) + 0.7*pdf(Normal(3, 1.5), x)

# Metropolis-Hastings algorithm
function metropolis_hastings(target, n_iter; proposal_sd=1.0)
    samples = zeros(n_iter)
    x_current = 0.0
    n_accepted = 0

    for i in 1:n_iter
        # Propose
        x_proposed = x_current + randn() * proposal_sd

        # Acceptance probability
        α = min(1, target(x_proposed) / target(x_current))

        # Accept/reject
        if rand() < α
            x_current = x_proposed
            n_accepted += 1
        end

        samples[i] = x_current
    end

    return samples, n_accepted / n_iter
end

# Run MCMC
n_iter = 10000
samples, acc_rate = metropolis_hastings(target_density, n_iter)

println("Acceptance rate: $(round(acc_rate, digits=3))")
println("Sample mean: $(round(mean(samples[1001:end]), digits=3))")

# Visualization
p1 = plot(samples[1:500], label="", xlabel="Iteration", ylabel="Value",
          title="Trace Plot (first 500)")

x_range = -5:0.05:8
p2 = histogram(samples[1001:end], bins=50, normalize=:pdf, label="MCMC samples", alpha=0.7)
plot!(p2, x_range, target_density.(x_range), linewidth=2, label="True density", color=:red)
title!(p2, "Samples vs Target")

p3 = plot(autocor(samples[1001:end], 0:100), marker=:circle, label="",
          xlabel="Lag", ylabel="ACF", title="Autocorrelation")

plot(p1, p2, p3, layout=(1, 3), size=(1500, 400))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/16.Markov_Chain_Monte_Carlo_I/metropolis_hastings_jl.png")
println("\nVisualization saved")
