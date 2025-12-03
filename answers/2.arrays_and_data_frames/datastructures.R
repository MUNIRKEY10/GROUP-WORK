# R code for "More Data Structures"

# Arrays
x <- c(7, 8, 10, 45)
x.arr <- array(x, dim = c(2, 2))
x.arr
dim(x.arr)
is.vector(x.arr)
is.array(x.arr)
typeof(x.arr)
str(x.arr)
attributes(x.arr)

# Accessing and operating on arrays
x.arr[1, 2]
x.arr[3]
x.arr[, 2]

# Functions on arrays
which(x.arr > 9)
y <- -x
y.arr <- array(y, dim = c(2, 2))
y.arr + x.arr
rowSums(x.arr)
colMeans(x.arr)
apply(x.arr, 1, mean)

# Matrices
factory <- matrix(c(40, 1, 60, 3), nrow = 2)
is.array(factory)
is.matrix(factory)

# Matrix multiplication
six.sevens <- matrix(rep(7, 6), ncol = 3)
six.sevens
factory %*% six.sevens

# Multiplying matrices and vectors
output <- c(10, 20)
factory %*% output
output %*% factory

# Matrix operators
t(factory)
det(factory)
diag(factory)
diag(factory) <- c(35, 4)
factory
diag(factory) <- c(40, 3)
diag(c(3, 4))
diag(2)
solve(factory)
factory %*% solve(factory)

# Solving linear systems
available <- c(1600, 70)
solve(factory, available)
factory %*% solve(factory, available)

# Names in matrices
rownames(factory) <- c("labor", "steel")
colnames(factory) <- c("cars", "trucks")
factory
available <- c(1600, 70)
names(available) <- c("labor", "steel")
output <- c(20, 10)
names(output) <- c("trucks", "cars")
factory %*% output
factory %*% output[colnames(factory)]
all(factory %*% output[colnames(factory)] <= available[rownames(factory)])

# Lists
my.distribution <- list("exponential", 7, FALSE)
my.distribution
is.character(my.distribution)
is.character(my.distribution[[1]])
my.distribution[[2]]^2

# Expanding and contracting lists
my.distribution <- c(my.distribution, 7)
my.distribution
length(my.distribution)
length(my.distribution) <- 3
my.distribution

# Naming list elements
names(my.distribution) <- c("family", "mean", "is.symmetric")
my.distribution
my.distribution[["family"]]
my.distribution["family"]
my.distribution$family

# Adding and removing named elements
another.distribution <- list(family = "gaussian", mean = 7, sd = 1, is.symmetric = TRUE)
my.distribution$was.estimated <- FALSE
my.distribution[["last.updated"]] <- "2011-08-30"
my.distribution$was.estimated <- NULL

# Dataframes
a.matrix <- matrix(c(35, 8, 10, 4), nrow = 2)
colnames(a.matrix) <- c("v1", "v2")
a.matrix
a.matrix[, "v1"]
a.data.frame <- data.frame(a.matrix, logicals = c(TRUE, FALSE))
a.data.frame
a.data.frame$v1
a.data.frame[, "v1"]
a.data.frame[1, ]
colMeans(a.data.frame)

# Adding rows and columns
rbind(a.data.frame, list(v1 = -3, v2 = -5, logicals = TRUE))
rbind(a.data.frame, c(3, 4, 6))

# Structures of Structures
plan <- list(factory = factory, available = available, output = output)
plan$output

# Eigen
eigen(factory)
class(eigen(factory))
factory %*% eigen(factory)$vectors[, 2]
eigen(factory)$values[2] * eigen(factory)$vectors[, 2]
eigen(factory)$values[2]
eigen(factory)[[1]][[2]]

# Example dataframe
library(datasets)
states <- data.frame(state.x77, abb = state.abb, region = state.region, division = state.division)
colnames(states)
states[1, ]
states[49, 3]
states["Wisconsin", "Illiteracy"]
states["Wisconsin", ]
head(states[, 3])
head(states[, "Illiteracy"])
head(states$Illiteracy)
states[states$division == "New England", "Illiteracy"]
states[states$region == "South", "Illiteracy"]
summary(states$HS.Grad)
states$HS.Grad <- states$HS.Grad / 100
summary(states$HS.Grad)
states$HS.Grad <- 100 * states$HS.Grad
with(states, head(100 * (HS.Grad / (100 - Illiteracy))))
plot(Illiteracy ~ Frost, data = states)
