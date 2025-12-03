# Kernel Density Estimation in Julia
using Distributions, Random, Plots, KernelDensity

println("=== Kernel Density Estimation ===\n")
Random.seed!(42)

# Generate data (bimodal)
data = vcat(randn(100), randn(100) .+ 5)

# KDE with different bandwidths
kde_default = kde(data)
kde_small = kde(data, bandwidth=0.5)
kde_large = kde(data, bandwidth=2.0)

# Visualization
p1 = histogram(data, bins=30, normalize=:pdf, alpha=0.5, label="Data", legend=:topright)
plot!(p1, kde_default.x, kde_default.density, linewidth=2, label="KDE", color=:red)
title!(p1, "Kernel Density Estimation")

p2 = plot(kde_small.x, kde_small.density, linewidth=2, label="h=0.5", color=:blue)
plot!(p2, kde_default.x, kde_default.density, linewidth=2, label="h=default", color=:red)
plot!(p2, kde_large.x, kde_large.density, linewidth=2, label="h=2.0", color=:green)
title!(p2, "Effect of Bandwidth")

plot(p1, p2, layout=(1, 2), size=(1400, 500))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/14.density_estimation/kernel_density_jl.png")
println("Visualization saved")
