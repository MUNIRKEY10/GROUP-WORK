using DataFrames
using GLM

# Create dummy data (or use the loaded data_frame)
data = DataFrame(X = [1, 2, 3, 4, 5], Y = [2, 4, 5, 4, 5])

# Fit the linear model: Y is predicted by X
model = lm(@formula(Y ~ X), data)

# Print the model summary
println(model)
