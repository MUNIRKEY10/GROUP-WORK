# K-Fold Cross-Validation in Julia
using Random, Statistics, GLM, DataFrames

println("=== K-Fold Cross-Validation ===\n")
Random.seed!(42)

# Generate synthetic data
n = 100
X = randn(n, 3)
y = 2*X[:,1] + 3*X[:,2] - X[:,3] + randn(n)*0.5

# Manual K-fold implementation
K = 5
fold_ids = shuffle(repeat(1:K, outer=Int(ceil(n/K)))[1:n])

println("--- Manual $K-Fold Cross-Validation ---\n")
mse_scores = Float64[]

for k in 1:K
    # Split data
    train_idx = fold_ids .!= k
    test_idx = fold_ids .== k

    X_train, X_test = X[train_idx, :], X[test_idx, :]
    y_train, y_test = y[train_idx], y[test_idx]

    # Fit model
    df_train = DataFrame(X_train, :auto)
    df_train.y = y_train
    model = lm(@formula(y ~ x1 + x2 + x3), df_train)

    # Predict and evaluate
    df_test = DataFrame(X_test, :auto)
    y_pred = predict(model, df_test)
    mse = mean((y_test .- y_pred).^2)
    push!(mse_scores, mse)

    println("Fold $k: MSE = $(round(mse, digits=4)), n_train = $(sum(train_idx)), n_test = $(sum(test_idx))")
end

println("\nMean CV MSE: $(round(mean(mse_scores), digits=4)) ± $(round(std(mse_scores), digits=4))")
