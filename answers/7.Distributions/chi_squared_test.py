"""
Chi-Squared Tests
Includes: Chi-squared test for association (contingency tables)
and Chi-squared goodness-of-fit test for continuous distributions
"""
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

print("=== Chi-Squared Tests ===\n")

# Example 1: Chi-squared test for association (Contingency Table)
print("--- Example 1: Test of Independence (Gender x Party Affiliation) ---\n")

# Create contingency table from the lesson
# Rows: Gender (Male, Female)
# Columns: Party (Democrat, Independent, Republican)
M = np.array([[762, 327, 468],
              [484, 239, 477]])

print("Contingency Table:")
print("                Democrat  Independent  Republican")
print(f"Male            {M[0,0]:7d}  {M[0,1]:11d}  {M[0,2]:10d}")
print(f"Female          {M[1,0]:7d}  {M[1,1]:11d}  {M[1,2]:10d}")
print()

# Perform chi-squared test
chi2, p_value, dof, expected = stats.chi2_contingency(M)

print(f"Chi-squared statistic: {chi2:.4f}")
print(f"Degrees of freedom: {dof}")
print(f"p-value: {p_value:.6e}")
print()

print("Expected frequencies:")
print("                Democrat  Independent  Republican")
print(f"Male            {expected[0,0]:7.2f}  {expected[0,1]:11.2f}  {expected[0,2]:10.2f}")
print(f"Female          {expected[1,0]:7.2f}  {expected[1,1]:11.2f}  {expected[1,2]:10.2f}")
print()

if p_value < 0.05:
    print("Conclusion: Reject H0. Gender and party affiliation are associated (dependent).")
else:
    print("Conclusion: Cannot reject H0. Gender and party affiliation may be independent.")

# Example 2: Chi-squared goodness-of-fit test for continuous distribution
print("\n" + "="*70)
print("--- Example 2: Goodness-of-Fit Test for Continuous Distribution ---\n")

# Generate sample data (simulating cat heart weight data)
np.random.seed(42)
cats_Hwt = np.random.gamma(shape=17.5, scale=0.607, size=144)

# Fit gamma distribution using method of moments
m = np.mean(cats_Hwt)
v = np.var(cats_Hwt, ddof=1)
fitted_shape = m**2 / v
fitted_scale = v / m

print(f"Sample size: {len(cats_Hwt)}")
print(f"Fitted Gamma parameters: shape={fitted_shape:.4f}, scale={fitted_scale:.4f}\n")

# Create histogram (without plotting)
counts, bin_edges = np.histogram(cats_Hwt, bins=[6, 8, 10, 12, 14, 16, 18, 20, 22])

print(f"Histogram bins: {bin_edges}")
print(f"Observed counts: {counts}")
print(f"Sum of counts: {np.sum(counts)}\n")

# Calculate theoretical probabilities for each bin
# Use -inf for first bin and +inf for last bin
prob_edges = np.concatenate([[-np.inf], bin_edges[1:-1], [np.inf]])
theoretical_probs = np.diff(stats.gamma.cdf(prob_edges, fitted_shape, scale=fitted_scale))

# Normalize probabilities
theoretical_probs = theoretical_probs / np.sum(theoretical_probs)

print(f"Theoretical probabilities: {theoretical_probs}")
print(f"Sum of probabilities: {np.sum(theoretical_probs):.6f}\n")

# Expected counts
expected_counts = theoretical_probs * len(cats_Hwt)
print(f"Expected counts: {expected_counts}")
print(f"Sum of expected: {np.sum(expected_counts):.2f}\n")

# Pad observed counts with zeros at beginning and end
# This accounts for bins with no observations
observed_padded = np.concatenate([[0], counts, [0]])

# Perform chi-squared test
chi2_stat, p_val_manual = stats.chisquare(observed_padded, expected_counts)

print(f"Chi-squared statistic: {chi2_stat:.4f}")

# Adjust degrees of freedom for estimated parameters
# df = number of bins - 1 - number of estimated parameters
df_adjusted = len(counts) + 2 - 2  # 2 parameters estimated (shape, scale)
p_val_adjusted = 1 - stats.chi2.cdf(chi2_stat, df_adjusted)

print(f"Degrees of freedom (adjusted): {df_adjusted}")
print(f"p-value (adjusted): {p_val_adjusted:.4f}\n")

if p_val_adjusted > 0.05:
    print("Conclusion: Cannot reject H0. Data is consistent with fitted Gamma distribution.")
else:
    print("Conclusion: Reject H0. Data may not follow fitted Gamma distribution.")

# Visualization
fig, axes = plt.subplots(1, 2, figsize=(14, 5))

# Plot 1: Contingency table visualization
categories = ['Democrat', 'Independent', 'Republican']
x = np.arange(len(categories))
width = 0.35

axes[0].bar(x - width/2, M[0], width, label='Male', alpha=0.8)
axes[0].bar(x + width/2, M[1], width, label='Female', alpha=0.8)
axes[0].set_xlabel('Party Affiliation')
axes[0].set_ylabel('Count')
axes[0].set_title('Gender x Party Affiliation')
axes[0].set_xticks(x)
axes[0].set_xticklabels(categories)
axes[0].legend()
axes[0].grid(True, alpha=0.3, axis='y')

# Plot 2: Observed vs Expected counts
bin_centers = (bin_edges[:-1] + bin_edges[1:]) / 2
axes[1].bar(bin_centers, counts, width=1.8, alpha=0.7, label='Observed', edgecolor='black')
axes[1].plot(bin_centers, expected_counts[1:-1], 'ro-', linewidth=2, markersize=8,
             label='Expected (Gamma)')
axes[1].set_xlabel('Heart Weight (g)')
axes[1].set_ylabel('Frequency')
axes[1].set_title('Chi-Squared Goodness-of-Fit Test')
axes[1].legend()
axes[1].grid(True, alpha=0.3, axis='y')

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/chi_squared_test.png', dpi=150)
print("\nVisualization saved as chi_squared_test.png")
plt.close()
