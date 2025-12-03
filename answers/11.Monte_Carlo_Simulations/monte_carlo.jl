# Monte Carlo Simulation in Julia
using Distributions, Random, Plots, Statistics

println("=== Monte Carlo Simulation ===\n")
Random.seed!(42)

# Example 1: Estimating E[X]
println("--- Example 1: Estimating E[X] for Normal Distribution ---")
μ, σ = 5, 2
for n in [10, 100, 1000, 10000]
    samples = rand(Normal(μ, σ), n)
    estimate = mean(samples)
    println("n=$n: E[X]=$(round(estimate, digits=6)), Error=$(round(abs(estimate-μ), digits=6))")
end

# Example 2: MC Integration ∫₀¹ x² dx
println("\n--- Example 2: Monte Carlo Integration ---")
f(x) = x^2
n_samples = 100000
x_samples = rand(Uniform(0, 1), n_samples)
mc_estimate = mean(f.(x_samples))
println("True: $(1/3), MC estimate: $(round(mc_estimate, digits=6))")

# Example 3: Estimating π
println("\n--- Example 3: Estimating π ---")
n_points = 100000
x, y = rand(n_points), rand(n_points)
inside = (x.^2 .+ y.^2) .<= 1
π_est = 4 * sum(inside) / n_points
println("π estimate: $(round(π_est, digits=6)), True: $(round(π, digits=6))")

# Visualization
max_n = 10000
samples = rand(Normal(μ, σ), max_n)
cum_means = cumsum(samples) ./ (1:max_n)

p1 = plot(1:max_n, cum_means, xscale=:log10, label="Estimate", linewidth=2)
hline!(p1, [μ], label="True mean", linewidth=2, linestyle=:dash, color=:red)
title!(p1, "Convergence")

p2 = plot(0:0.01:1, f, label="f(x)=x²", fill=(0, 0.3), linewidth=2)
title!(p2, "MC Integration")

p3 = scatter(x[inside][1:1000], y[inside][1:1000], markersize=1, label="Inside", alpha=0.5)
scatter!(p3, x[.!inside][1:1000], y[.!inside][1:1000], markersize=1, label="Outside", alpha=0.5)
plot!(p3, cos.(0:0.01:π/2), sin.(0:0.01:π/2), linewidth=2, label="", color=:black)
title!(p3, "Estimating π")

plot(p1, p2, p3, layout=(1, 3), size=(1400, 400))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/11.Monte_Carlo_Simulations/monte_carlo_jl.png")
println("\nVisualization saved")
