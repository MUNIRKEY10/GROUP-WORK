# Method of Moments Estimation
# Estimates distribution parameters by matching theoretical and sample moments

using Distributions
using Random
using Optim
using Statistics

# Generate sample data from Gamma distribution
Random.seed!(42)
true_shape, true_scale = 5, 2
sample_data = rand(Gamma(true_shape, true_scale), 1000)

println("=== Method of Moments: Closed Form ===\n")
println("True parameters: shape=$true_shape, scale=$true_scale")
println("Sample mean: ", round(mean(sample_data), digits=4))
println("Sample variance: ", round(var(sample_data), digits=4))

# Method of Moments for Gamma Distribution (Closed Form)
function gamma_est_MM(x)
    """
    Estimate Gamma parameters using method of moments
    For Gamma distribution:
    - E[X] = shape * scale
    - Var[X] = shape * scale^2

    Solving:
    - shape = mean^2 / variance
    - scale = variance / mean
    """
    m = mean(x)
    v = var(x)

    shape = m^2 / v
    scale = v / m

    return (shape=shape, scale=scale)
end

mm_estimates = gamma_est_MM(sample_data)
println("\nMethod of Moments estimates:")
println("  shape = ", round(mm_estimates.shape, digits=4))
println("  scale = ", round(mm_estimates.scale, digits=4))

# Verify the estimates
println("\nVerification:")
theoretical_mean = mm_estimates.shape * mm_estimates.scale
theoretical_var = mm_estimates.shape * mm_estimates.scale^2
println("  Theoretical mean: ", round(theoretical_mean, digits=4),
        " (sample: ", round(mean(sample_data), digits=4), ")")
println("  Theoretical var:  ", round(theoretical_var, digits=4),
        " (sample: ", round(var(sample_data), digits=4), ")")

println("\n", "="^60)
println("=== Method of Moments: Numerical Optimization ===\n")

# Helper functions for gamma distribution moments
gamma_mean(shape, scale) = shape * scale
gamma_var(shape, scale) = shape * scale^2

# Discrepancy function to minimize
function gamma_discrepancy(params, x)
    """
    Calculate squared discrepancy between theoretical and sample moments
    """
    shape, scale = params

    if shape <= 0 || scale <= 0
        return 1e10  # Return large value for invalid parameters
    end

    mean_discrepancy = (mean(x) - gamma_mean(shape, scale))^2
    var_discrepancy = (var(x) - gamma_var(shape, scale))^2

    return mean_discrepancy + var_discrepancy
end

# Initial guess
initial_params = [1.0, 1.0]

# Optimize using Optim.jl
result = optimize(p -> gamma_discrepancy(p, sample_data), initial_params,
                  NelderMead())

println("Optimization result:")
println("  Converged: ", Optim.converged(result))
println("  shape = ", round(Optim.minimizer(result)[1], digits=4))
println("  scale = ", round(Optim.minimizer(result)[2], digits=4))
println("  Discrepancy: ", @sprintf("%.6e", Optim.minimum(result)))

# Compare both methods
println("\n", "="^60)
println("=== Comparison ===\n")
@printf("%-30s %-10s %-10s\n", "Method", "Shape", "Scale")
println("-"^50)
@printf("%-30s %-10.4f %-10.4f\n", "True values", true_shape, true_scale)
@printf("%-30s %-10.4f %-10.4f\n", "Closed form MM",
        mm_estimates.shape, mm_estimates.scale)
@printf("%-30s %-10.4f %-10.4f\n", "Numerical MM",
        Optim.minimizer(result)[1], Optim.minimizer(result)[2])
