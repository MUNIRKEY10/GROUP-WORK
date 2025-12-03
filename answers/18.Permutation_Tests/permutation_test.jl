# Permutation Tests in Julia
using Distributions, Random, Plots, Statistics

println("=== Permutation Test ===\n")
Random.seed!(42)

# Generate two samples
group1 = rand(Normal(10, 2), 30)
group2 = rand(Normal(11.5, 2), 30)

# Observed test statistic
obs_diff = mean(group1) - mean(group2)
println("Observed difference: $(round(obs_diff, digits=4))\n")

# Permutation test
n_permutations = 10000
perm_diffs = Float64[]
combined = vcat(group1, group2)
n1 = length(group1)

for _ in 1:n_permutations
    # Shuffle labels
    perm_idx = randperm(length(combined))
    perm_g1 = combined[perm_idx[1:n1]]
    perm_g2 = combined[perm_idx[n1+1:end]]

    push!(perm_diffs, mean(perm_g1) - mean(perm_g2))
end

# Calculate p-value (two-tailed)
p_value = mean(abs.(perm_diffs) .>= abs(obs_diff))
println("Permutation p-value: $(round(p_value, digits=4))\n")

# Visualization
histogram(perm_diffs, bins=50, normalize=:pdf, alpha=0.7,
          xlabel="Difference in Means", ylabel="Density",
          label="", title="Permutation Distribution (p-value = $(round(p_value, digits=4)))")
vline!([obs_diff, -obs_diff], linewidth=2, linestyle=:dash, color=:red,
       label="Observed diff = $(round(obs_diff, digits=3))")

savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/18.Permutation_Tests/permutation_test_jl.png")
println("Visualization saved")
