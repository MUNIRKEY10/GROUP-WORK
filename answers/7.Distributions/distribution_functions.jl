# Distribution Functions: d, p, q, r pattern
# Demonstrates the four types of distribution functions:
# - pdf: Probability density function
# - cdf: Cumulative distribution function
# - quantile: Quantile function (inverse CDF)
# - rand: Random variates

using Distributions
using Plots
using Random

# Example with Exponential Distribution
println("=== Exponential Distribution Functions ===\n")

# Define range
x_range = 0:0.05:8

# 1. Density function (PDF)
println("1. Density function (pdf):")
pdf_1 = pdf.(Exponential(1.0), x_range)  # rate=1, mean=1
pdf_2 = pdf.(Exponential(2.0), x_range)  # rate=0.5, mean=2
pdf_3 = pdf.(Exponential(5.0), x_range)  # rate=0.2, mean=5
println("   PDF at x=1 with rate=1: ", round(pdf(Exponential(1.0), 1), digits=4))

# 2. Cumulative distribution function (CDF)
println("\n2. Cumulative distribution function (cdf):")
cdf_1 = cdf.(Exponential(1.0), x_range)
cdf_2 = cdf.(Exponential(2.0), x_range)
cdf_3 = cdf.(Exponential(5.0), x_range)
println("   P(X < 1) with rate=1: ", round(cdf(Exponential(1.0), 1), digits=4))

# 3. Quantile function (inverse CDF)
println("\n3. Quantile function (quantile):")
q_value = quantile(Exponential(1.0), 0.5)
println("   Median (50th percentile) with rate=1: ", round(q_value, digits=4))
println("   95th percentile with rate=1: ", round(quantile(Exponential(1.0), 0.95), digits=4))

# 4. Random variates
println("\n4. Random variates (rand):")
Random.seed!(42)
random_samples = rand(Exponential(1.0), 10)
println("   10 random samples: ", random_samples)

# Visualization
p1 = plot(x_range, pdf_1, label="rate=1.0", linewidth=2,
          title="Exponential PDF (Density)", xlabel="x", ylabel="f(x)")
plot!(p1, x_range, pdf_2, label="rate=0.5", linewidth=2)
plot!(p1, x_range, pdf_3, label="rate=0.2", linewidth=2)

p2 = plot(x_range, cdf_1, label="rate=1.0", linewidth=2,
          title="Exponential CDF (Probability)", xlabel="x", ylabel="P(X < x)")
plot!(p2, x_range, cdf_2, label="rate=0.5", linewidth=2)
plot!(p2, x_range, cdf_3, label="rate=0.2", linewidth=2)

# Normal distribution examples
x_norm = -4:0.05:4
p3 = plot(x_norm, pdf.(Normal(0, 1), x_norm), label="μ=0, σ=1", linewidth=2,
          title="Normal Distribution PDF", xlabel="x", ylabel="f(x)")
plot!(p3, x_norm, pdf.(Normal(0, 0.5), x_norm), label="μ=0, σ=0.5", linewidth=2)
plot!(p3, x_norm, pdf.(Normal(1, 1), x_norm), label="μ=1, σ=1", linewidth=2)

# Gamma distribution examples
x_gamma = 0:0.1:20
p4 = plot(x_gamma, pdf.(Gamma(2, 2), x_gamma), label="shape=2, scale=2", linewidth=2,
          title="Gamma Distribution PDF", xlabel="x", ylabel="f(x)")
plot!(p4, x_gamma, pdf.(Gamma(5, 1), x_gamma), label="shape=5, scale=1", linewidth=2)
plot!(p4, x_gamma, pdf.(Gamma(1, 2), x_gamma), label="shape=1, scale=2", linewidth=2)

plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 1000))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/distribution_functions_jl.png")
println("\nVisualization saved as distribution_functions_jl.png")

# Summary of common distributions
println("\n=== Common Distributions in Julia (Distributions.jl) ===")
println("Continuous: Normal, Exponential, Gamma, Beta, Chisq, TDist, FDist, Uniform, LogNormal, Weibull")
println("Discrete: Binomial, Poisson, NegativeBinomial, Geometric, Hypergeometric")
println("\nAll support: pdf, cdf, quantile, rand functions")
