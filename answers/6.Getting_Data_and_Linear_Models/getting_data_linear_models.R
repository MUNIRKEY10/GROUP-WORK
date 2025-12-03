# R code for "Getting Data and Linear Models"

# --- Loading and Saving R Objects ---
# The gmp.dat file should have been created in the previous chapter's code generation.
# Assuming gmp.dat exists and can be read.
gmp <- read.table("gmp.dat", header = TRUE)
# R likes factors for categorical data, so we'll add a dummy one
gmp$MSA <- factor(paste0("MSA_", 1:nrow(gmp)))
# Calculate pop from gmp and pcgmp based on previous chapter's logic
gmp$pop <- round(gmp$gmp / gmp$pcgmp)

save(gmp, file = "gmp.Rda")
rm(gmp)
print(exists("gmp"))
load(file = "gmp.Rda")
print(colnames(gmp))
print(gmp)

# Using data() for built-in datasets
library(MASS) # For cats and birthwt datasets
data(cats, package = "MASS")
print(summary(cats))

# --- Reading and Writing Dataframes ---
# The gmp.dat file is already read above.
# Example of writing a CSV
write.csv(gmp, file = "gmp.csv", row.names = FALSE)

# --- Exploring and Preparing Birth Weight Data ---
data(birthwt)
# Make it readable: Rename columns
colnames(birthwt) <- c("birthwt.below.2500", "mother.age", "mother.weight", "race",
                       "mother.smokes", "previous.prem.labor", "hypertension", "uterine.irr",
                       "physician.visits", "birthwt.grams")

# Make it readable: Recode factors
birthwt$race <- factor(c("white", "black", "other")[birthwt$race])
birthwt$mother.smokes <- factor(c("No", "Yes")[birthwt$mother.smokes + 1])
birthwt$uterine.irr <- factor(c("No", "Yes")[birthwt$uterine.irr + 1])
birthwt$hypertension <- factor(c("No", "Yes")[birthwt$hypertension + 1])

print(summary(birthwt))

# Explore it with plots
pdf("birthwt_race_plot.pdf", width=7, height=5)
plot(birthwt$race)
title(main = "Count of Mother's Race in Springfield MA, 1986")
dev.off()

pdf("birthwt_mother_age_plot.pdf", width=7, height=5)
plot(birthwt$mother.age)
title(main = "Mother's Ages in Springfield MA, 1986", ylab = "Mother's Age")
dev.off()

pdf("birthwt_mother_age_sorted_plot.pdf", width=7, height=5)
plot(sort(birthwt$mother.age))
title(main = "(Sorted) Mother's Ages in Springfield MA, 1986", ylab = "Mother's Age")
dev.off()

pdf("birthwt_age_vs_grams_plot.pdf", width=7, height=5)
plot(birthwt$mother.age, birthwt$birthwt.grams)
title(main = "Birth Weight by Mother's Age in Springfield MA, 1986",
       xlab = "Mother's Age", ylab = "Birth Weight (g)")
dev.off()

pdf("birthwt_smokes_vs_grams_plot.pdf", width=7, height=5)
plot(birthwt$mother.smokes, birthwt$birthwt.grams, main = "Birth Weight by Mother's Smoking Habit",
      ylab = "Birth Weight (g)", xlab = "Mother Smokes")
dev.off()

# --- Basic Statistical Testing (Linear Models) ---
# Two-sample t-test
t_test_result <- t.test(birthwt$birthwt.grams[birthwt$mother.smokes == "Yes"],
                        birthwt$birthwt.grams[birthwt$mother.smokes == "No"])
print(t_test_result)

# Linear model with smoking
linear.model.1 <- lm(birthwt.grams ~ mother.smokes, data = birthwt)
print(linear.model.1)
print(summary(linear.model.1))

# Linear model with age
linear.model.2 <- lm(birthwt.grams ~ mother.age, data = birthwt)
print(linear.model.2)
print(summary(linear.model.2))

# Plot diagnostics for linear.model.2
pdf("linear_model_2_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2)) # Arrange plots in a 2x2 grid
plot(linear.model.2)
par(mfrow = c(1,1)) # Reset plot layout
dev.off()

# Detecting Outliers: remove mother.age > 40
birthwt.noout <- birthwt[birthwt$mother.age <= 40,]
linear.model.3 <- lm(birthwt.grams ~ mother.age, data = birthwt.noout)
print(linear.model.3)
print(summary(linear.model.3))

# More complex models
# Add smoking behavior to age model
linear.model.3a <- lm(birthwt.grams ~ mother.smokes + mother.age, data = birthwt.noout)
print(summary(linear.model.3a))

pdf("linear_model_3a_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2))
plot(linear.model.3a)
par(mfrow = c(1,1))
dev.off()

# Add race and interaction to age + smoking model
linear.model.3b <- lm(birthwt.grams ~ mother.age + mother.smokes * race, data = birthwt.noout)
print(summary(linear.model.3b))

pdf("linear_model_3b_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2))
plot(linear.model.3b)
par(mfrow = c(1,1))
dev.off()

# Including everything (excluding redundant outcome variable)
linear.model.4a <- lm(birthwt.grams ~ . - birthwt.below.2500, data = birthwt.noout)
print(summary(linear.model.4a))

pdf("linear_model_4a_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2))
plot(linear.model.4a)
par(mfrow = c(1,1))
dev.off()

# --- Generalized Linear Models (GLM) ---
# GLM with Gaussian family (equivalent to lm)
glm.0 <- glm(birthwt.grams ~ . - birthwt.below.2500, data = birthwt.noout, family = gaussian(link = "identity"))
print(summary(glm.0))

pdf("glm_0_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2))
plot(glm.0)
par(mfrow = c(1,1))
dev.off()

# GLM with Binomial family (for binary outcome: birthwt.below.2500)
glm.1 <- glm(birthwt.below.2500 ~ . - birthwt.grams, data = birthwt.noout, family = binomial(link = logit))
print(summary(glm.1))

pdf("glm_1_diagnostics.pdf", width=10, height=8)
par(mfrow = c(2,2))
plot(glm.1)
par(mfrow = c(1,1))
dev.off()

# --- Prediction ---
# Split data into training and test sets
odds <- seq(1, nrow(birthwt.noout), by = 2)
birthwt.in <- birthwt.noout[odds,]
birthwt.out <- birthwt.noout[-odds,]

linear.model.half <- lm(birthwt.grams ~ . - birthwt.below.2500, data = birthwt.in)
print(summary(linear.model.half))

# Prediction on training data
birthwt.predict.in <- predict(linear.model.half)
print(cor(birthwt.in$birthwt.grams, birthwt.predict.in))
pdf("birthwt_predict_in_plot.pdf", width=7, height=5)
plot(birthwt.in$birthwt.grams, birthwt.predict.in, 
     xlab = "Actual Birth Weight (g)", ylab = "Predicted Birth Weight (g)",
     main = "Prediction on Training Data")
dev.off()

# Prediction on test data
birthwt.predict.out <- predict(linear.model.half, birthwt.out)
print(cor(birthwt.out$birthwt.grams, birthwt.predict.out))
pdf("birthwt_predict_out_plot.pdf", width=7, height=5)
plot(birthwt.out$birthwt.grams, birthwt.predict.out, 
     xlab = "Actual Birth Weight (g)", ylab = "Predicted Birth Weight (g)",
     main = "Prediction on Test Data")
dev.off()
