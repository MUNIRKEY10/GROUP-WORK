"""
Linear Congruential Generator (LCG) Implementation
X_{n+1} = (a*X_n + c) mod m
Demonstrates a simple pseudo-random number generator
"""
import numpy as np
import matplotlib.pyplot as plt

class LCG:
    """Linear Congruential Generator"""
    def __init__(self, seed, a, c, m):
        self.seed = seed
        self.a = a
        self.c = c
        self.m = m
        self.current = seed

    def next(self):
        """Generate next value"""
        self.current = (self.a * self.current + self.c) % self.m
        return self.current

    def generate(self, n):
        """Generate n random values"""
        return [self.next() for _ in range(n)]

# Example 1: Poor generator with short period (8)
print("Poor LCG parameters (a=5, c=1, m=16):")
print("Expected period: 8")
poor_lcg = LCG(seed=10, a=5, c=1, m=16)
poor_sequence = poor_lcg.generate(20)
print(f"Generated sequence: {poor_sequence}")

# Example 2: Better generator with longer period
print("\nBetter LCG parameters (a=1103515245, c=12345, m=2^31):")
better_lcg = LCG(seed=10, a=1103515245, c=12345, m=2**31)
better_sequence = better_lcg.generate(20)
print(f"Generated sequence (first 20): {better_sequence}")

# Normalize to [0,1] and visualize
better_lcg_viz = LCG(seed=10, a=1103515245, c=12345, m=2**31)
large_sequence = [better_lcg_viz.next() / (2**31) for _ in range(1000)]

plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.hist(large_sequence, bins=30, edgecolor='black')
plt.title('Distribution of LCG Values')
plt.xlabel('Value')
plt.ylabel('Frequency')

plt.subplot(1, 2, 2)
plt.plot(large_sequence[:100], 'o-', markersize=3)
plt.title('First 100 LCG Values')
plt.xlabel('Index')
plt.ylabel('Value')

plt.tight_layout()
plt.savefig('/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/lcg_visualization.png', dpi=150)
print("\nVisualization saved as lcg_visualization.png")
plt.close()
