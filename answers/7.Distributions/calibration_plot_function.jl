# Exercise: General Calibration Plot Function
# Creates a calibration plot that inputs a data vector, cumulative probability function,
# and parameters

using Distributions
using Random
using Plots
using Statistics

function calibration_plot(data::Vector, dist::Distribution;
                         title::String="Calibration Plot",
                         show_plot::Bool=true)
    """
    Create a calibration plot for goodness of fit assessment

    Parameters:
    -----------
    data : Vector
        The observed data vector
    dist : Distribution
        Distribution object from Distributions.jl
        Examples: Gamma(5, 2), Normal(0, 1), Exponential(2)
    title : String
        Title for the plot
    show_plot : Bool
        Whether to display the plot immediately

    Returns:
    --------
    plot object
    """
    # Transform data using CDF
    cdf_values = cdf.(dist, data)

    # Calculate empirical CDF of transformed values
    sorted_cdf = sort(cdf_values)
    empirical_cdf = (1:length(sorted_cdf)) ./ length(sorted_cdf)

    # Create plot
    p = plot(sorted_cdf, empirical_cdf, linetype=:steppost, linewidth=2,
             label="Empirical CDF", color=:blue)

    # Add diagonal reference line
    plot!(p, [0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:gray,
          label="Perfect calibration")

    # Formatting
    xlabel!(p, "Theoretical CDF")
    ylabel!(p, "Empirical CDF")
    title!(p, title)
    xlims!(p, 0, 1)
    ylims!(p, 0, 1)

    if show_plot
        display(p)
    end

    return p
end


# Example usage and demonstration
println("=== Calibration Plot Function Demonstration ===\n")

# Generate sample data
Random.seed!(42)

# Example 1: Well-fitted distribution
println("Example 1: Gamma data fitted with Gamma distribution")
gamma_data = rand(Gamma(5, 2), 200)
m = mean(gamma_data)
v = var(gamma_data)
fitted_shape = m^2 / v
fitted_scale = v / m

println("True parameters: shape=5, scale=2")
println("Fitted parameters: shape=", round(fitted_shape, digits=4),
        ", scale=", round(fitted_scale, digits=4), "\n")

# Example 2: Poorly-fitted distribution
println("Example 2: Normal data fitted with Gamma distribution (poor fit)")
normal_data = rand(Normal(10, 2), 200)
# Force-fit gamma distribution
m2 = mean(normal_data)
v2 = var(normal_data)
forced_shape = m2^2 / v2
forced_scale = v2 / m2
println("Forced Gamma fit: shape=", round(forced_shape, digits=4),
        ", scale=", round(forced_scale, digits=4), "\n")

# Example 3: Exponential distribution
println("Example 3: Exponential data fitted with Exponential distribution")
exp_data = rand(Exponential(2), 200)
fitted_scale_exp = mean(exp_data)
println("True scale: 2.0")
println("Fitted scale: ", round(fitted_scale_exp, digits=4), "\n")

# Create comparison plot
p1 = calibration_plot(gamma_data, Gamma(fitted_shape, fitted_scale),
                     title="Good Fit: Gamma-Gamma", show_plot=false)

p2 = calibration_plot(normal_data, Gamma(forced_shape, forced_scale),
                     title="Poor Fit: Normal-Gamma", show_plot=false)

p3 = calibration_plot(exp_data, Exponential(fitted_scale_exp),
                     title="Good Fit: Exponential-Exponential", show_plot=false)

plot(p1, p2, p3, layout=(1,3), size=(1500, 500))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/calibration_plot_function_jl.png")
println("Visualization saved as calibration_plot_function_jl.png")

# Additional example: Using with Normal distribution
println("\n=== Additional Example ===\n")
println("Example with Normal distribution:")
norm_data = rand(Normal(5, 2), 100)
fitted_mean = mean(norm_data)
fitted_sd = std(norm_data)

p_norm = calibration_plot(norm_data, Normal(fitted_mean, fitted_sd),
                         title="Normal Distribution Calibration",
                         show_plot=false)
savefig(p_norm, "/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/calibration_example_normal_jl.png")
println("Normal calibration plot saved")
