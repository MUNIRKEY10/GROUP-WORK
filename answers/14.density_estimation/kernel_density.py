"""
Kernel Density Estimation
Non-parametric density estimation using kernels
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde
from sklearn.neighbors import KernelDensity

print("=== Kernel Density Estimation ===\n")

# Generate data
np.random.seed(42)
data = np.concatenate([np.random.normal(0, 1, 100), np.random.normal(5, 1.5, 100)])

# KDE using scipy
kde_scipy = gaussian_kde(data, bw_method='scott')
x_range = np.linspace(-5, 10, 500)
density_scipy = kde_scipy(x_range)

# KDE using sklearn with different bandwidths
bandwidths = [0.5, 1.0, 2.0]
fig, axes = plt.subplots(1, 2, figsize=(14, 5))

axes[0].hist(data, bins=30, density=True, alpha=0.5, label='Data')
axes[0].plot(x_range, density_scipy, 'r-', linewidth=2, label='KDE (scipy)')
axes[0].set_title('Kernel Density Estimation')
axes[0].legend()

for bw in bandwidths:
    kde = KernelDensity(bandwidth=bw, kernel='gaussian')
    kde.fit(data.reshape(-1, 1))
    log_dens = kde.score_samples(x_range.reshape(-1, 1))
    axes[1].plot(x_range, np.exp(log_dens), label=f'h={bw}')

axes[1].set_title('Effect of Bandwidth')
axes[1].legend()
plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/14.density_estimation/kernel_density.png', dpi=150)
print("Visualization saved")
plt.close()
