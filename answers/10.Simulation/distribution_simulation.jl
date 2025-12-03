# Distribution Simulation in Julia
# Simulating random variables from various probability distributions

using Distributions
using Random
using Plots
using Statistics

println("=== Distribution Simulation ===\n")

# Set seed for reproducibility
Random.seed!(42)

# Key Concept: Four types of distribution functions
println("--- Four Distribution Functions ---")
println("1. pdf/pmf: Probability density/mass function")
println("2. cdf: Cumulative distribution function")
println("3. quantile: Inverse CDF (percentile)")
println("4. rand: Generate random samples\n")

# Example with Normal distribution
println("Example: Normal Distribution N(μ=5, σ=2)")
μ, σ = 5, 2
x = 6

println("\n1. PDF at x=$x: ", round(pdf(Normal(μ, σ), x), digits=6))
println("2. CDF P(X ≤ $x): ", round(cdf(Normal(μ, σ), x), digits=6))
println("3. 95th percentile: ", round(quantile(Normal(μ, σ), 0.95), digits=6))
println("4. Random sample (n=5): ", rand(Normal(μ, σ), 5))

# Common distributions and their simulation
println("\n--- Simulating Common Distributions ---\n")

n_samples = 1000

# 1. Normal
normal_samples = rand(Normal(μ, σ), n_samples)
println("1. Normal(5, 2): mean=$(round(mean(normal_samples), digits=3)), std=$(round(std(normal_samples), digits=3))")

# 2. Exponential
exp_samples = rand(Exponential(2.0), n_samples)  # scale=2 means rate=0.5
println("2. Exponential(λ=0.5): mean=$(round(mean(exp_samples), digits=3))")

# 3. Binomial
binom_samples = rand(Binomial(10, 0.3), n_samples)
println("3. Binomial(n=10, p=0.3): mean=$(round(mean(binom_samples), digits=3))")

# 4. Poisson
poisson_samples = rand(Poisson(4.5), n_samples)
println("4. Poisson(λ=4.5): mean=$(round(mean(poisson_samples), digits=3))")

# 5. Uniform
uniform_samples = rand(Uniform(0, 1), n_samples)
println("5. Uniform(0, 1): mean=$(round(mean(uniform_samples), digits=3))")

# Visualization
p1 = histogram(normal_samples, bins=30, normalize=:pdf, label="Data",
               xlabel="Value", ylabel="Density", title="Normal(5, 2)", alpha=0.7)
x_range = range(minimum(normal_samples), maximum(normal_samples), length=100)
plot!(p1, x_range, pdf.(Normal(μ, σ), x_range), linewidth=2, label="PDF", color=:red)

p2 = histogram(exp_samples, bins=30, normalize=:pdf, label="Data",
               xlabel="Value", title="Exponential(λ=0.5)", alpha=0.7)
x_range = range(0, maximum(exp_samples), length=100)
plot!(p2, x_range, pdf.(Exponential(2.0), x_range), linewidth=2, label="PDF", color=:red)

p3 = histogram(binom_samples, bins=-0.5:1:10.5, normalize=:pdf, label="Data",
               xlabel="Value", title="Binomial(n=10, p=0.3)", alpha=0.7)
x_vals = 0:10
plot!(p3, x_vals, pdf.(Binomial(10, 0.3), x_vals), marker=:circle,
      linewidth=2, label="PMF", color=:red)

p4 = histogram(poisson_samples, bins=-0.5:1:14.5, normalize=:pdf, label="Data",
               xlabel="Value", title="Poisson(λ=4.5)", alpha=0.7)
x_vals = 0:14
plot!(p4, x_vals, pdf.(Poisson(4.5), x_vals), marker=:circle,
      linewidth=2, label="PMF", color=:red)

p5 = histogram(uniform_samples, bins=30, normalize=:pdf, label="Data",
               xlabel="Value", title="Uniform(0, 1)", alpha=0.7, ylims=(0, 1.5))
hline!(p5, [1], linewidth=2, label="PDF", color=:red)

p6 = scatter(quantile.(Normal(), (1:n_samples) ./ (n_samples+1)),
             sort(normal_samples), label="", xlabel="Theoretical Quantiles",
             ylabel="Sample Quantiles", title="Q-Q Plot (Normal)", alpha=0.5)
plot!(p6, [-3, 3], [-3, 3], linewidth=2, linestyle=:dash, color=:red, label="")

plot(p1, p2, p3, p4, p5, p6, layout=(2, 3), size=(1500, 1000))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/10.Simulation/distribution_simulation_jl.png")
println("\nVisualization saved as distribution_simulation_jl.png")
