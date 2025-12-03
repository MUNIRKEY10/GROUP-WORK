# Random Number Generation with Seed Setting
# Demonstrates basic uniform random number generation and reproducibility

using Random

# Basic uniform random number generation
println("Random numbers without seed:")
random_nums = rand(10)
println(random_nums)

# With seed for reproducibility
println("\nRandom numbers with seed (10):")
Random.seed!(10)
random_nums_seeded = rand(10)
println(random_nums_seeded)

# Verify reproducibility
println("\nSame seed produces same numbers:")
Random.seed!(10)
random_nums_verify = rand(10)
println(random_nums_verify)
println("Arrays are equal: ", random_nums_seeded == random_nums_verify)
