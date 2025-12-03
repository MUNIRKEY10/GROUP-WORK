# Maximum Likelihood Estimation (MLE)
# Estimates distribution parameters by maximizing the likelihood function

using Distributions
using Random
using Optim
using Statistics
using Printf

# Generate sample data from Gamma distribution
Random.seed!(42)
true_shape, true_scale = 5, 2
sample_data = rand(Gamma(true_shape, true_scale), 1000)

println("=== Maximum Likelihood Estimation ===\n")
println("True parameters: shape=$true_shape, scale=$true_scale")
println("Sample size: ", length(sample_data))

# Define log-likelihood function for Exponential distribution
function loglike_exp(rate, x)
    """
    Log-likelihood for exponential distribution
    """
    if rate <= 0
        return 1e10  # Return large value for invalid parameters
    end

    # Sum of log densities
    return -sum(logpdf.(Exponential(1/rate), x))
end

# MLE for Exponential (for demonstration)
Random.seed!(42)
exp_data = rand(Exponential(2.0), 100)
result_exp = optimize(r -> loglike_exp(r[1], exp_data), [0.5], LBFGS(),
                      Optim.Options(g_tol=1e-6))

println("\n--- Exponential Distribution MLE ---")
println("Estimated rate: ", round(Optim.minimizer(result_exp)[1], digits=4))
println("True rate (1/scale): ", round(1/2.0, digits=4))
println("MLE using mean: ", round(1/mean(exp_data), digits=4))

# Define log-likelihood function for Gamma distribution
function loglike_gamma(params, x)
    """
    Log-likelihood for gamma distribution
    We minimize the negative log-likelihood
    """
    shape, scale = params

    if shape <= 0 || scale <= 0
        return 1e10
    end

    # Sum of log densities
    return -sum(logpdf.(Gamma(shape, scale), x))
end

# Manual MLE for Gamma
println("\n--- Gamma Distribution MLE (Manual) ---")
initial_params = [1.0, 1.0]
result = optimize(p -> loglike_gamma(p, sample_data), initial_params,
                  LBFGS(), Optim.Options(g_tol=1e-6))

println("Optimization converged: ", Optim.converged(result))
println("Estimated shape: ", round(Optim.minimizer(result)[1], digits=4))
println("Estimated scale: ", round(Optim.minimizer(result)[2], digits=4))
println("Negative log-likelihood: ", round(Optim.minimum(result), digits=4))

# Using Distributions.jl fit method
println("\n--- Gamma Distribution MLE (Distributions.jl) ---")
fit_result = fit(Gamma, sample_data)
println("Estimated shape: ", round(shape(fit_result), digits=4))
println("Estimated scale: ", round(scale(fit_result), digits=4))

# Method of Moments for comparison
println("\n--- Method of Moments (for comparison) ---")
m = mean(sample_data)
v = var(sample_data)
mm_shape = m^2 / v
mm_scale = v / m
println("Estimated shape: ", round(mm_shape, digits=4))
println("Estimated scale: ", round(mm_scale, digits=4))

# Comparison
println("\n", "="^70)
println("=== Comparison ===\n")
@printf("%-30s %-15s %-15s\n", "Method", "Shape", "Scale")
println("-"^70)
@printf("%-30s %-15.4f %-15.4f\n", "True values", true_shape, true_scale)
@printf("%-30s %-15.4f %-15.4f\n", "MLE (manual)",
        Optim.minimizer(result)[1], Optim.minimizer(result)[2])
@printf("%-30s %-15.4f %-15.4f\n", "MLE (Distributions.jl)",
        shape(fit_result), scale(fit_result))
@printf("%-30s %-15.4f %-15.4f\n", "Method of Moments", mm_shape, mm_scale)

# Log-likelihood comparison
ll_true = -loglike_gamma([true_shape, true_scale], sample_data)
ll_mle = -Optim.minimum(result)
ll_mm = -loglike_gamma([mm_shape, mm_scale], sample_data)

@printf("\n%-30s %-15s\n", "Method", "Log-Likelihood")
println("-"^70)
@printf("%-30s %-15.4f\n", "True parameters", ll_true)
@printf("%-30s %-15.4f\n", "MLE", ll_mle)
@printf("%-30s %-15.4f\n", "Method of Moments", ll_mm)

println("\nMLE maximizes log-likelihood")
