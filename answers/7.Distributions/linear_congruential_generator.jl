# Linear Congruential Generator (LCG) Implementation
# X_{n+1} = (a*X_n + c) mod m
# Demonstrates a simple pseudo-random number generator

using Plots

# LCG struct
mutable struct LCG
    seed::Int
    a::Int
    c::Int
    m::Int
    current::Int

    LCG(seed, a, c, m) = new(seed, a, c, m, seed)
end

# Generate next value
function next!(lcg::LCG)
    lcg.current = (lcg.a * lcg.current + lcg.c) % lcg.m
    return lcg.current
end

# Generate n values
function generate(lcg::LCG, n::Int)
    return [next!(lcg) for _ in 1:n]
end

# Example 1: Poor generator with short period (8)
println("Poor LCG parameters (a=5, c=1, m=16):")
println("Expected period: 8")
poor_lcg = LCG(10, 5, 1, 16)
poor_sequence = generate(poor_lcg, 20)
println("Generated sequence: ", poor_sequence)

# Example 2: Better generator with longer period
println("\nBetter LCG parameters (a=1103515245, c=12345, m=2^31):")
better_lcg = LCG(10, 1103515245, 12345, 2^31)
better_sequence = generate(better_lcg, 20)
println("Generated sequence (first 20): ", better_sequence)

# Normalize to [0,1] and visualize
better_lcg_viz = LCG(10, 1103515245, 12345, 2^31)
large_sequence = [next!(better_lcg_viz) / (2^31) for _ in 1:1000]

p1 = histogram(large_sequence, bins=30, title="Distribution of LCG Values",
               xlabel="Value", ylabel="Frequency", legend=false)

p2 = plot(large_sequence[1:100], marker=:circle, markersize=3,
          title="First 100 LCG Values", xlabel="Index", ylabel="Value",
          legend=false)

plot(p1, p2, layout=(1,2), size=(1200,400))
savefig("/home/titan/pdfs/notes/statisticalComputingAndReporting/groupWork/answers/7.Distributions/lcg_visualization_jl.png")
println("\nVisualization saved as lcg_visualization_jl.png")
