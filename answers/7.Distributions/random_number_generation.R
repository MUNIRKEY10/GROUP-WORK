# Random Number Generation with Seed Setting
# Demonstrates basic uniform random number generation and reproducibility

# Basic uniform random number generation
cat("Random numbers without seed:\n")
random_nums <- runif(10)
print(random_nums)

# With seed for reproducibility
cat("\nRandom numbers with seed (10):\n")
set.seed(10)
random_nums_seeded <- runif(10)
print(random_nums_seeded)

# Verify reproducibility
cat("\nSame seed produces same numbers:\n")
set.seed(10)
random_nums_verify <- runif(10)
print(random_nums_verify)
cat(sprintf("Arrays are equal: %s\n", all.equal(random_nums_seeded, random_nums_verify)))
