# Goodness of Fit Tests
# Includes: QQ plots, Calibration plots, and Kolmogorov-Smirnov test

using Distributions
using Random
using Statistics
using Plots
using StatsBase
using HypothesisTests
using Printf

# Generate sample data
Random.seed!(42)
sample_data = rand(Gamma(5, 2), 100)

# Fit gamma distribution using method of moments
m = mean(sample_data)
v = var(sample_data)
fitted_shape = m^2 / v
fitted_scale = v / m

println("=== Goodness of Fit Tests ===\n")
println("Sample size: ", length(sample_data))
@printf("Fitted parameters: shape=%.4f, scale=%.4f\n", fitted_shape, fitted_scale)

# 1. QQ Plot
println("\n--- QQ Plot ---")
println("Compares sample quantiles to theoretical quantiles")

fitted_dist = Gamma(fitted_shape, fitted_scale)
theoretical_quantiles = quantile.(fitted_dist, range(0.01, 0.99, length=length(sample_data)))
observed_quantiles = sort(sample_data)

p1 = scatter(theoretical_quantiles, observed_quantiles, alpha=0.6,
             xlabel="Theoretical Quantiles", ylabel="Observed Quantiles",
             title="QQ Plot", legend=false)
plot!(p1, [minimum(theoretical_quantiles), maximum(theoretical_quantiles)],
      [minimum(theoretical_quantiles), maximum(theoretical_quantiles)],
      linewidth=2, linestyle=:dash, color=:red, label="Perfect fit")

# 2. Calibration Plot
println("\n--- Calibration Plot ---")
println("Shows empirical CDF of theoretical CDF values")
println("Should follow diagonal if distribution fits well")

# Transform data using fitted CDF
cdf_values = cdf.(fitted_dist, sample_data)

# Calculate empirical CDF of these values
sorted_cdf = sort(cdf_values)
empirical_cdf = (1:length(sorted_cdf)) ./ length(sorted_cdf)

p2 = plot(sorted_cdf, empirical_cdf, linetype=:steppost, linewidth=2,
          label="Empirical CDF", xlabel="Theoretical CDF", ylabel="Empirical CDF",
          title="Calibration Plot")
plot!(p2, [0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:gray,
      label="Perfect calibration")
xlims!(p2, 0, 1)
ylims!(p2, 0, 1)

# 3. Kolmogorov-Smirnov Test
println("\n--- Kolmogorov-Smirnov Test (One-sample) ---")
ks_result = ExactOneSampleKSTest(sample_data, fitted_dist)
@printf("KS statistic (D): %.6f\n", ks_result.δ)
@printf("p-value: %.4f\n", pvalue(ks_result))

if pvalue(ks_result) > 0.05
    println("Conclusion: Cannot reject H0. Data is consistent with fitted distribution.")
else
    println("Conclusion: Reject H0. Data may not follow fitted distribution.")
end

# Visualize KS test
x_sorted = sort(sample_data)
theoretical_cdf_vals = cdf.(fitted_dist, x_sorted)
empirical_cdf_full = (1:length(x_sorted)) ./ length(x_sorted)

p3 = plot(x_sorted, empirical_cdf_full, linetype=:steppost, linewidth=2,
          label="Empirical CDF", xlabel="Value", ylabel="Cumulative Probability",
          title="Kolmogorov-Smirnov Test Visualization")
plot!(p3, x_sorted, theoretical_cdf_vals, linewidth=2, color=:red, label="Theoretical CDF")

# Show maximum difference
idx_max = argmax(abs.(empirical_cdf_full .- theoretical_cdf_vals))
plot!(p3, [x_sorted[idx_max], x_sorted[idx_max]],
      [empirical_cdf_full[idx_max], theoretical_cdf_vals[idx_max]],
      linewidth=2, color=:green, label=@sprintf("Max diff (D=%.3f)", ks_result.δ))

# 4. Two-sample KS Test
println("\n--- Kolmogorov-Smirnov Test (Two-sample) ---")
println("Comparing two samples from different distributions")

# Generate two samples
Random.seed!(42)
sample1 = rand(Normal(0, 1), 100)
sample2 = rand(Normal(0.5, 1), 100)

ks_2sample = ApproximateTwoSampleKSTest(sample1, sample2)
println("Sample 1: N(0, 1), n=100")
println("Sample 2: N(0.5, 1), n=100")
@printf("KS statistic (D): %.6f\n", ks_2sample.δ)
@printf("p-value: %.4f\n", pvalue(ks_2sample))

if pvalue(ks_2sample) < 0.05
    println("Conclusion: Reject H0. Samples come from different distributions.")
else
    println("Conclusion: Cannot reject H0. Samples may come from same distribution.")
end

# Visualize two-sample comparison
x1_sorted = sort(sample1)
x2_sorted = sort(sample2)
ecdf1 = (1:length(x1_sorted)) ./ length(x1_sorted)
ecdf2 = (1:length(x2_sorted)) ./ length(x2_sorted)

p4 = plot(x1_sorted, ecdf1, linetype=:steppost, linewidth=2, label="Sample 1",
          xlabel="Value", ylabel="Cumulative Probability",
          title="Two-Sample KS Test")
plot!(p4, x2_sorted, ecdf2, linetype=:steppost, linewidth=2, label="Sample 2")

plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 1000))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/goodness_of_fit_jl.png")
println("\nVisualization saved as goodness_of_fit_jl.png")
