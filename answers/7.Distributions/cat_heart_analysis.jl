# Cat Heart Weight Analysis
# Practical example: Fitting gamma distribution to cat heart weight data
# Uses method of moments and maximum likelihood estimation

using Distributions
using Random
using Statistics
using Plots
using Printf
using StatsBase
using HypothesisTests

# Load/simulate cat data (since MASS cats is R-specific)
# Using characteristics of the actual MASS cats dataset
Random.seed!(42)
n_cats = 144
cats_Hwt = rand(Gamma(17.5, 0.607), n_cats)  # Approximates real data

println("=== Cat Heart Weight Analysis ===\n")
println("Sample size: ", length(cats_Hwt))
@printf("Mean heart weight: %.4f g\n", mean(cats_Hwt))
@printf("SD heart weight: %.4f g\n", std(cats_Hwt))
@printf("Min: %.4f g, Max: %.4f g\n", minimum(cats_Hwt), maximum(cats_Hwt))

# Method of Moments estimation
println("\n--- Method of Moments Estimation ---")
function gamma_est_MM(x)
    m = mean(x)
    v = var(x)
    return (shape=m^2/v, scale=v/m)
end

mm_estimates = gamma_est_MM(cats_Hwt)
@printf("Shape: %.4f\n", mm_estimates.shape)
@printf("Scale: %.4f\n", mm_estimates.scale)
@printf("Rate: %.4f\n", 1/mm_estimates.scale)

# Maximum Likelihood Estimation
println("\n--- Maximum Likelihood Estimation ---")
mle_fit = fit(Gamma, cats_Hwt)
@printf("Shape: %.4f\n", shape(mle_fit))
@printf("Scale: %.4f\n", scale(mle_fit))
@printf("Rate: %.4f\n", 1/scale(mle_fit))

# Compare with the lesson's result
println("\n--- Comparison with Lesson Results ---")
println("Results may differ due to simulated data")
println("Lesson results: shape = 20.2998, rate = 1.9096")

# Create visualizations
p1 = histogram(cats_Hwt, bins=15, xlabel="Heart Weight (g)", ylabel="Frequency",
               title="Histogram of Cat Heart Weights", legend=false, alpha=0.7)

# Overlay fitted density on histogram
x_range = range(0, maximum(cats_Hwt)+2, length=200)
p2 = histogram(cats_Hwt, bins=15, normalize=:pdf, xlabel="Heart Weight (g)",
               ylabel="Density", title="Fitted Gamma Distribution",
               label="Data", alpha=0.7)
plot!(p2, x_range, pdf.(Gamma(mm_estimates.shape, mm_estimates.scale), x_range),
      linewidth=2, label="MM fit", color=:red)
plot!(p2, x_range, pdf.(mle_fit, x_range),
      linewidth=2, label="MLE fit", color=:blue)

# QQ plot
sorted_data = sort(cats_Hwt)
theoretical_quantiles = quantile.(Gamma(mm_estimates.shape, mm_estimates.scale),
                                 range(0.01, 0.99, length=length(cats_Hwt)))
p3 = scatter(theoretical_quantiles, sorted_data, xlabel="Theoretical Quantiles",
             ylabel="Observed Quantiles", title="QQ Plot (Method of Moments)",
             legend=false, alpha=0.6)
plot!(p3, [minimum(theoretical_quantiles), maximum(theoretical_quantiles)],
      [minimum(theoretical_quantiles), maximum(theoretical_quantiles)],
      linewidth=2, linestyle=:dash, color=:red)

# Kernel density estimation
kde_result = kde(cats_Hwt)
p4 = plot(kde_result.x, kde_result.density, linewidth=2, label="Kernel Density",
          xlabel="Heart Weight (g)", ylabel="Density",
          title="Kernel Density vs. Fitted Distribution")
plot!(p4, x_range, pdf.(Gamma(mm_estimates.shape, mm_estimates.scale), x_range),
      linewidth=2, linestyle=:dash, label="Fitted Gamma", color=:red)

plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 1000))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/cat_heart_analysis_jl.png")
println("\nVisualization saved as cat_heart_analysis_jl.png")

# Goodness of fit test (Kolmogorov-Smirnov)
println("\n--- Kolmogorov-Smirnov Test ---")
gamma_dist = Gamma(mm_estimates.shape, mm_estimates.scale)
ks_result = ExactOneSampleKSTest(cats_Hwt, gamma_dist)
@printf("KS statistic: %.6f\n", ks_result.δ)
@printf("p-value: %.4f\n", pvalue(ks_result))
if pvalue(ks_result) > 0.05
    println("Conclusion: Cannot reject H0. Data is consistent with Gamma distribution.")
else
    println("Conclusion: Reject H0. Data may not follow Gamma distribution.")
end
