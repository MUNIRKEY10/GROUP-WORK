# Bootstrap Resampling in Julia
using Distributions, Random, Plots, Statistics, StatsBase

println("=== Bootstrap Resampling ===\n")
Random.seed!(42)

# Generate data
n = 50
data = rand(Normal(10, 3), n)

println("Sample size: $n")
println("Sample mean: $(round(mean(data), digits=4))")
println("Sample std: $(round(std(data), digits=4))\n")

# Nonparametric Bootstrap
println("--- Nonparametric Bootstrap ---")
n_bootstrap = 10000

bootstrap_means = [mean(sample(data, n, replace=true)) for _ in 1:n_bootstrap]

println("Bootstrap mean: $(round(mean(bootstrap_means), digits=4))")
println("Bootstrap SE: $(round(std(bootstrap_means), digits=4))")
println("Theoretical SE: $(round(std(data)/sqrt(n), digits=4))\n")

# 95% CI
ci_lower, ci_upper = quantile(bootstrap_means, [0.025, 0.975])
println("95% Bootstrap CI: [$(round(ci_lower, digits=4)), $(round(ci_upper, digits=4))]\n")

# Bootstrap for other statistics
println("--- Bootstrap for Median and Std Dev ---")
bootstrap_medians = [median(sample(data, n, replace=true)) for _ in 1:n_bootstrap]
bootstrap_stds = [std(sample(data, n, replace=true)) for _ in 1:n_bootstrap]

println("Median: $(round(median(data), digits=4)), Bootstrap SE: $(round(std(bootstrap_medians), digits=4))")
println("Std Dev: $(round(std(data), digits=4)), Bootstrap SE: $(round(std(bootstrap_stds), digits=4))\n")

# Parametric Bootstrap
println("--- Parametric Bootstrap ---")
fitted_dist = fit(Normal, data)
parametric_means = [mean(rand(fitted_dist, n)) for _ in 1:n_bootstrap]
println("Parametric bootstrap SE: $(round(std(parametric_means), digits=4))")

# Visualization
p1 = histogram(data, bins=15, normalize=:pdf, label="Data", alpha=0.7)
plot!(p1, x->pdf(fitted_dist, x), linewidth=2, label="Fitted", color=:red)
vline!(p1, [mean(data)], linewidth=2, linestyle=:dash, label="Mean", color=:blue)
title!(p1, "Original Data")

p2 = histogram(bootstrap_means, bins=50, normalize=:pdf, label="Bootstrap", alpha=0.7)
vline!(p2, [mean(data)], linewidth=2, linestyle=:dash, label="Sample mean", color=:red)
vline!(p2, [ci_lower, ci_upper], linewidth=2, linestyle=:dash, label="95% CI", color=:green)
title!(p2, "Bootstrap Distribution of Mean")

p3 = histogram(bootstrap_medians, bins=50, normalize=:pdf, label="Median", alpha=0.5, color=:red)
histogram!(p3, bootstrap_means, bins=50, normalize=:pdf, label="Mean", alpha=0.5, color=:blue)
title!(p3, "Mean vs Median")

p4 = histogram(bootstrap_means, bins=50, normalize=:pdf, label="Nonparametric", alpha=0.5, color=:blue)
histogram!(p4, parametric_means, bins=50, normalize=:pdf, label="Parametric", alpha=0.5, color=:red)
title!(p4, "Nonparametric vs Parametric")

plot(p1, p2, p3, p4, layout=(2,2), size=(1400, 1000))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/12.Bootstrap/bootstrap_jl.png")
println("\nVisualization saved")
