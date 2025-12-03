# K-Fold Cross-Validation in R

cat("=== K-Fold Cross-Validation ===\n\n")
set.seed(42)

# Generate synthetic data
n <- 100
X <- matrix(rnorm(n*3), ncol=3)
y <- 2*X[,1] + 3*X[,2] - X[,3] + rnorm(n)*0.5

# Manual K-fold implementation
K <- 5
fold.ids <- sample(rep(1:K, length.out=n))

cat(sprintf("--- Manual %d-Fold Cross-Validation ---\n\n", K))
mse.scores <- numeric(K)

for(k in 1:K) {
  # Split data
  train.idx <- fold.ids != k
  test.idx <- fold.ids == k

  X.train <- X[train.idx, ]
  X.test <- X[test.idx, ]
  y.train <- y[train.idx]
  y.test <- y[test.idx]

  # Fit model
  model <- lm(y.train ~ X.train)

  # Predict and evaluate
  y.pred <- predict(model, newdata=data.frame(X.train=X.test))
  mse <- mean((y.test - y.pred)^2)
  mse.scores[k] <- mse

  cat(sprintf("Fold %d: MSE = %.4f, n_train = %d, n_test = %d\n",
              k, mse, sum(train.idx), sum(test.idx)))
}

cat(sprintf("\nMean CV MSE: %.4f ± %.4f\n", mean(mse.scores), sd(mse.scores)))

# Using caret package
if(require(caret, quietly=TRUE)) {
  cat("\n--- Using caret package ---\n\n")
  train.control <- trainControl(method="cv", number=K)
  model.cv <- train(y ~ ., data=data.frame(X, y),
                    method="lm", trControl=train.control)
  cat(sprintf("CV RMSE: %.4f\n", model.cv$results$RMSE))
  cat(sprintf("CV MSE: %.4f\n", model.cv$results$RMSE^2))
} else {
  cat("\nInstall 'caret' package for additional CV functionality\n")
}
