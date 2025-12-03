"""
Random Number Generation with Seed Setting
Demonstrates basic uniform random number generation and reproducibility
"""
import numpy as np

# Basic uniform random number generation
print("Random numbers without seed:")
random_nums = np.random.uniform(0, 1, 10)
print(random_nums)

# With seed for reproducibility
print("\nRandom numbers with seed (10):")
np.random.seed(10)
random_nums_seeded = np.random.uniform(0, 1, 10)
print(random_nums_seeded)

# Verify reproducibility
print("\nSame seed produces same numbers:")
np.random.seed(10)
random_nums_verify = np.random.uniform(0, 1, 10)
print(random_nums_verify)
print(f"Arrays are equal: {np.array_equal(random_nums_seeded, random_nums_verify)}")
