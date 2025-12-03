# Chi-Squared Tests
# Includes: Chi-squared test for association (contingency tables)
# and Chi-squared goodness-of-fit test for continuous distributions

using Distributions
using Random
using HypothesisTests
using Statistics
using Plots
using Printf
using StatsBase

println("=== Chi-Squared Tests ===\n")

# Example 1: Chi-squared test for association (Contingency Table)
println("--- Example 1: Test of Independence (Gender x Party Affiliation) ---\n")

# Create contingency table from the lesson
# Rows: Gender (Male, Female)
# Columns: Party (Democrat, Independent, Republican)
M = [762 327 468;
     484 239 477]

println("Contingency Table:")
println("                Democrat  Independent  Republican")
@printf("Male            %7d  %11d  %10d\n", M[1,1], M[1,2], M[1,3])
@printf("Female          %7d  %11d  %10d\n", M[2,1], M[2,2], M[2,3])
println()

# Perform chi-squared test
chi_test = ChisqTest(M)

@printf("Chi-squared statistic: %.4f\n", chi_test.stat)
@printf("Degrees of freedom: %d\n", dof(chi_test))
@printf("p-value: %.6e\n", pvalue(chi_test))
println()

println("Expected frequencies:")
expected = expected_frequencies(chi_test)
println("                Democrat  Independent  Republican")
@printf("Male            %7.2f  %11.2f  %10.2f\n", expected[1,1], expected[1,2], expected[1,3])
@printf("Female          %7.2f  %11.2f  %10.2f\n", expected[2,1], expected[2,2], expected[2,3])
println()

if pvalue(chi_test) < 0.05
    println("Conclusion: Reject H0. Gender and party affiliation are associated (dependent).")
else
    println("Conclusion: Cannot reject H0. Gender and party affiliation may be independent.")
end

# Example 2: Chi-squared goodness-of-fit test for continuous distribution
println("\n", "="^70)
println("--- Example 2: Goodness-of-Fit Test for Continuous Distribution ---\n")

# Generate sample data (simulating cat heart weight data)
Random.seed!(42)
cats_Hwt = rand(Gamma(17.5, 0.607), 144)

# Fit gamma distribution using method of moments
m = mean(cats_Hwt)
v = var(cats_Hwt)
fitted_shape = m^2 / v
fitted_scale = v / m

@printf("Sample size: %d\n", length(cats_Hwt))
@printf("Fitted Gamma parameters: shape=%.4f, scale=%.4f\n\n", fitted_shape, fitted_scale)

# Create histogram
bin_edges = [6, 8, 10, 12, 14, 16, 18, 20, 22]
counts = fit(Histogram, cats_Hwt, bin_edges).weights

println("Histogram bins: ", bin_edges)
println("Observed counts: ", counts)
@printf("Sum of counts: %d\n\n", sum(counts))

# Calculate theoretical probabilities for each bin
# Use -Inf for first bin and Inf for last bin
p_edges = vcat([-Inf], bin_edges[2:end-1], [Inf])
theoretical_probs = diff(cdf.(Gamma(fitted_shape, fitted_scale), p_edges))

# Normalize probabilities
theoretical_probs = theoretical_probs ./ sum(theoretical_probs)

println("Theoretical probabilities: ", theoretical_probs)
@printf("Sum of probabilities: %.6f\n\n", sum(theoretical_probs))

# Expected counts
expected_counts = theoretical_probs .* length(cats_Hwt)
println("Expected counts: ", expected_counts)
@printf("Sum of expected: %.2f\n\n", sum(expected_counts))

# Pad observed counts with zeros at beginning and end
observed_padded = vcat([0], counts, [0])

# Calculate chi-squared statistic manually
chi2_stat = sum((observed_padded .- expected_counts).^2 ./ expected_counts)

@printf("Chi-squared statistic: %.4f\n", chi2_stat)

# Adjust degrees of freedom for estimated parameters
# df = number of bins - 1 - number of estimated parameters
df_adjusted = length(counts) + 2 - 2  # 2 parameters estimated
p_val_adjusted = 1 - cdf(Chisq(df_adjusted), chi2_stat)

@printf("Degrees of freedom (adjusted): %d\n", df_adjusted)
@printf("p-value (adjusted): %.4f\n\n", p_val_adjusted)

if p_val_adjusted > 0.05
    println("Conclusion: Cannot reject H0. Data is consistent with fitted Gamma distribution.")
else
    println("Conclusion: Reject H0. Data may not follow fitted Gamma distribution.")
end

# Visualization
p1 = groupedbar(["Democrat" "Independent" "Republican"],
                [M[1,:]' ; M[2,:]'],
                label=["Male" "Female"],
                title="Gender x Party Affiliation",
                xlabel="Party Affiliation",
                ylabel="Count",
                legend=:topright)

# Plot 2: Observed vs Expected counts
bin_centers = (bin_edges[1:end-1] .+ bin_edges[2:end]) ./ 2
p2 = bar(bin_centers, counts, label="Observed", alpha=0.7,
         xlabel="Heart Weight (g)", ylabel="Frequency",
         title="Chi-Squared Goodness-of-Fit Test",
         bar_width=1.8)
plot!(p2, bin_centers, expected_counts[2:end-1], marker=:circle, markersize=8,
      linewidth=2, color=:red, label="Expected (Gamma)")

plot(p1, p2, layout=(1,2), size=(1400, 500))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/chi_squared_test_jl.png")
println("\nVisualization saved as chi_squared_test_jl.png")
