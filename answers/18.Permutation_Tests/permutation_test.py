"""
Permutation Tests
Non-parametric hypothesis testing by shuffling labels
"""
import numpy as np
import matplotlib.pyplot as plt

print("=== Permutation Test ===\n")

# Generate two samples
np.random.seed(42)
group1 = np.random.normal(10, 2, 30)
group2 = np.random.normal(11.5, 2, 30)

# Observed test statistic (difference in means)
obs_diff = np.mean(group1) - np.mean(group2)
print(f"Observed difference: {obs_diff:.4f}\n")

# Permutation test
n_permutations = 10000
perm_diffs = []
combined = np.concatenate([group1, group2])
n1 = len(group1)

for _ in range(n_permutations):
    # Shuffle labels
    perm_idx = np.random.permutation(len(combined))
    perm_g1 = combined[perm_idx[:n1]]
    perm_g2 = combined[perm_idx[n1:]]

    perm_diff = np.mean(perm_g1) - np.mean(perm_g2)
    perm_diffs.append(perm_diff)

perm_diffs = np.array(perm_diffs)

# Calculate p-value (two-tailed)
p_value = np.mean(np.abs(perm_diffs) >= np.abs(obs_diff))
print(f"Permutation p-value: {p_value:.4f}\n")

# Visualization
plt.figure(figsize=(10, 6))
plt.hist(perm_diffs, bins=50, density=True, alpha=0.7, edgecolor='black')
plt.axvline(obs_diff, color='r', linestyle='--', linewidth=2, label=f'Observed diff = {obs_diff:.3f}')
plt.axvline(-obs_diff, color='r', linestyle='--', linewidth=2)
plt.xlabel('Difference in Means')
plt.ylabel('Density')
plt.title(f'Permutation Distribution (p-value = {p_value:.4f})')
plt.legend()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/18.Permutation_Tests/permutation_test.png', dpi=150)
print("Visualization saved")
plt.close()
