# Gibbs Sampling in Julia
using Distributions, Random, Plots

println("=== Gibbs Sampling ===\n")
Random.seed!(42)

# Bivariate normal with correlation
ρ = 0.8
n_iterations = 5000

# Gibbs sampler
samples = zeros(n_iterations, 2)
x, y = 0.0, 0.0

for i in 1:n_iterations
    # Sample x | y
    x = rand(Normal(ρ * y, sqrt(1 - ρ^2)))
    # Sample y | x
    y = rand(Normal(ρ * x, sqrt(1 - ρ^2)))

    samples[i, :] = [x, y]
end

println("Sample correlation: $(round(cor(samples[1001:end, 1], samples[1001:end, 2]), digits=3))")
println("True correlation: $ρ\n")

# Visualization
p1 = plot(samples[1:500, 1], samples[1:500, 2], linewidth=0.5, alpha=0.3,
          label="", color=:blue)
scatter!(p1, samples[1:500, 1], samples[1:500, 2], markersize=2,
         marker_z=1:500, color=:viridis, label="")
xlabel!(p1, "X")
ylabel!(p1, "Y")
title!(p1, "Gibbs Sampling Path (first 500)")

p2 = scatter(samples[1001:end, 1], samples[1001:end, 2],
             markersize=1, alpha=0.3, label="", color=:blue)
xlabel!(p2, "X")
ylabel!(p2, "Y")
title!(p2, "Samples (after burn-in)")

plot(p1, p2, layout=(1, 2), size=(1200, 500))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/17.Markov_Chain_Monte_Carlo_II/gibbs_sampling_jl.png")
println("Visualization saved")
