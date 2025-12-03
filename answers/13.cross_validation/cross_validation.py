"""
K-Fold Cross-Validation
Assessing model performance using training/testing splits
"""
import numpy as np
from sklearn.model_selection import KFold, cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

print("=== K-Fold Cross-Validation ===\n")

# Generate synthetic data
np.random.seed(42)
n = 100
X = np.random.randn(n, 3)
y = 2*X[:, 0] + 3*X[:, 1] - X[:, 2] + np.random.randn(n)*0.5

# Manual K-fold implementation
K = 5
fold_ids = np.random.permutation(np.repeat(range(K), len(y)//K + 1)[:len(y)])

print(f"--- Manual {K}-Fold Cross-Validation ---\n")
mse_scores = []

for k in range(K):
    # Split data
    train_idx = fold_ids != k
    test_idx = fold_ids == k

    X_train, X_test = X[train_idx], X[test_idx]
    y_train, y_test = y[train_idx], y[test_idx]

    # Fit model
    model = LinearRegression()
    model.fit(X_train, y_train)

    # Predict and evaluate
    y_pred = model.predict(X_test)
    mse = mean_squared_error(y_test, y_pred)
    mse_scores.append(mse)

    print(f"Fold {k+1}: MSE = {mse:.4f}, n_train = {len(y_train)}, n_test = {len(y_test)}")

print(f"\nMean CV MSE: {np.mean(mse_scores):.4f} ± {np.std(mse_scores):.4f}")

# Using sklearn
print(f"\n--- Using sklearn KFold ---\n")
model = LinearRegression()
kf = KFold(n_splits=K, shuffle=True, random_state=42)
cv_scores = -cross_val_score(model, X, y, cv=kf, scoring='neg_mean_squared_error')

print(f"CV MSE scores: {cv_scores}")
print(f"Mean: {np.mean(cv_scores):.4f} ± {np.std(cv_scores):.4f}")
