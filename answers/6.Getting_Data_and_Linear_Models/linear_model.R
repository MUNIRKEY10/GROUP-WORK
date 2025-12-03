# Create dummy data (or use the loaded data_frame)
data_frame <- data.frame(
  X = c(1, 2, 3, 4, 5),
  Y = c(2, 4, 5, 4, 5)
)

# Fit the linear model: Y is predicted by X
model <- lm(Y ~ X, data = data_frame)

# Print the model summary (coefficients, p-values, etc.)
summary(model)
