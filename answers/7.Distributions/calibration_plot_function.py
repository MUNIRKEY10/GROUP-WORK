"""
Exercise: General Calibration Plot Function
Creates a calibration plot that inputs a data vector, cumulative probability function,
and parameter dictionary
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

def calibration_plot(data, cdf_func, params=None, title="Calibration Plot",
                     show_plot=True, ax=None):
    """
    Create a calibration plot for goodness of fit assessment

    Parameters:
    -----------
    data : array-like
        The observed data vector
    cdf_func : callable
        Cumulative distribution function that takes (x, **params) as arguments
        Examples: stats.gamma.cdf, stats.norm.cdf
    params : dict, optional
        Dictionary of parameters to pass to cdf_func
        Example: {'a': 5, 'scale': 2} for Gamma distribution
    title : str
        Title for the plot
    show_plot : bool
        Whether to display the plot immediately
    ax : matplotlib axis, optional
        Axis to plot on. If None, creates new figure

    Returns:
    --------
    fig, ax : matplotlib figure and axis objects (if ax was None)
    ax : matplotlib axis object (if ax was provided)
    """
    # Handle parameters
    if params is None:
        params = {}

    # Transform data using CDF
    cdf_values = cdf_func(data, **params)

    # Calculate empirical CDF of transformed values
    sorted_cdf = np.sort(cdf_values)
    empirical_cdf = np.arange(1, len(sorted_cdf) + 1) / len(sorted_cdf)

    # Create plot
    if ax is None:
        fig, ax = plt.subplots(figsize=(8, 8))
        return_fig = True
    else:
        return_fig = False

    # Plot empirical CDF
    ax.step(sorted_cdf, empirical_cdf, where='post', linewidth=2,
            label='Empirical CDF', color='blue')

    # Plot diagonal reference line
    ax.plot([0, 1], [0, 1], 'gray', linewidth=2, linestyle='--',
            label='Perfect calibration')

    # Formatting
    ax.set_xlabel('Theoretical CDF', fontsize=12)
    ax.set_ylabel('Empirical CDF', fontsize=12)
    ax.set_title(title, fontsize=14)
    ax.set_xlim([0, 1])
    ax.set_ylim([0, 1])
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    if show_plot:
        plt.tight_layout()
        plt.show()

    if return_fig:
        return fig, ax
    else:
        return ax


# Example usage and demonstration
if __name__ == "__main__":
    print("=== Calibration Plot Function Demonstration ===\n")

    # Generate sample data
    np.random.seed(42)

    # Example 1: Well-fitted distribution
    print("Example 1: Gamma data fitted with Gamma distribution")
    gamma_data = np.random.gamma(5, 2, 200)
    m = np.mean(gamma_data)
    v = np.var(gamma_data, ddof=1)
    fitted_shape = m**2 / v
    fitted_scale = v / m

    print(f"True parameters: shape=5, scale=2")
    print(f"Fitted parameters: shape={fitted_shape:.4f}, scale={fitted_scale:.4f}\n")

    # Example 2: Poorly-fitted distribution
    print("Example 2: Normal data fitted with Gamma distribution (poor fit)")
    normal_data = np.random.normal(10, 2, 200)
    # Force-fit gamma distribution
    m2 = np.mean(normal_data)
    v2 = np.var(normal_data, ddof=1)
    forced_shape = m2**2 / v2
    forced_scale = v2 / m2
    print(f"Forced Gamma fit: shape={forced_shape:.4f}, scale={forced_scale:.4f}\n")

    # Example 3: Exponential distribution
    print("Example 3: Exponential data fitted with Exponential distribution")
    exp_data = np.random.exponential(2, 200)
    fitted_scale_exp = np.mean(exp_data)
    print(f"True scale: 2.0")
    print(f"Fitted scale: {fitted_scale_exp:.4f}\n")

    # Create comparison plot
    fig, axes = plt.subplots(1, 3, figsize=(15, 5))

    # Plot 1: Good fit (Gamma-Gamma)
    calibration_plot(gamma_data, stats.gamma.cdf,
                    params={'a': fitted_shape, 'scale': fitted_scale},
                    title="Good Fit: Gamma-Gamma",
                    show_plot=False, ax=axes[0])

    # Plot 2: Poor fit (Normal-Gamma)
    calibration_plot(normal_data, stats.gamma.cdf,
                    params={'a': forced_shape, 'scale': forced_scale},
                    title="Poor Fit: Normal-Gamma",
                    show_plot=False, ax=axes[1])

    # Plot 3: Good fit (Exponential-Exponential)
    calibration_plot(exp_data, stats.expon.cdf,
                    params={'scale': fitted_scale_exp},
                    title="Good Fit: Exponential-Exponential",
                    show_plot=False, ax=axes[2])

    plt.tight_layout()
    plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/calibration_plot_function.png', dpi=150)
    print("Visualization saved as calibration_plot_function.png")
    plt.close()
