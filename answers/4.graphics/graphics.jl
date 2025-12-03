using Plots
using Random

# Set plotting backend (e.g., pyplot(), gr(), plotly())
pyplot() 

# 1. Create dummy data
Random.seed!(42)
data = rand(10, 10)

# 2. Generate the heatmap
heatmap(data, 
        title = "Julia Heatmap", 
        c = :viridis, 
        aspect_ratio = 1)
