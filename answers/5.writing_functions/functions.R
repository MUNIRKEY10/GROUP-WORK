# R code for "Writing Functions"

# Example cubic function
cube <- function(x) x ^ 3
print(cube(3))
print(cube(1:10))
print(cube(matrix(1:8, 2, 4)))
print(mode(cube))

# Example psi.1 function (robust loss function)
psi.1 <- function(x) {
  psi <- ifelse(x^2 > 1, 2 * abs(x) - 1, x^2)
  return(psi)
}
z <- c(-0.5, -5, 0.9, 9)
print(psi.1(z))

# Named and default arguments
psi.2 <- function(x, c = 1) {
  psi <- ifelse(x^2 > c^2, 2 * c * abs(x) - c^2, x^2)
  return(psi)
}
print(identical(psi.1(z), psi.2(z, c = 1)))
print(identical(psi.2(z, c = 1), psi.2(z)))
print(identical(psi.2(x = z, c = 2), psi.2(c = 2, x = z)))

# Checking arguments with stopifnot()
psi.3 <- function(x, c = 1) {
  stopifnot(length(c) == 1, c > 0)
  psi <- ifelse(x^2 > c^2, 2 * c * abs(x) - c^2, x^2)
  return(psi)
}
# These will throw errors:
# try(psi.3(x = z, c = c(1, 1, 1, 10)))
# try(psi.3(x = z, c = -1))

# Internal environment examples
x <- 7
y <- c("A", "C", "G", "T", "U")
adder <- function(y_arg) { # Renamed y to y_arg to avoid confusion with global y
  x_internal <- x + y_arg # x is from global scope, y_arg is function arg
  return(x_internal)
}
print(adder(1))
print(x) # Global x remains unchanged
print(y) # Global y remains unchanged

circle.area <- function(r) { return(pi * r^2) }
print(circle.area(c(1, 2, 3)))
truepi <- pi
pi <- 3 # Global pi is changed
print(circle.area(c(1, 2, 3))) # Function uses modified global pi
pi <- truepi # Restore sanity
print(circle.area(c(1, 2, 3)))

# Fitting a Model (Power-Law Scaling)
# Load gmp.dat for the example
gmp <- read.table("gmp.dat", header = TRUE)
gmp$pop <- gmp$gmp / gmp$pcgmp

# Initial attempt (code from slide 20)
# (This section is for demonstration of bad practices, not directly a function call)
maximum.iterations <- 100
deriv.step <- 1/1000
step.scale <- 1e-12
stopping.deriv <- 1/100
iteration <- 0
deriv <- Inf
a <- 0.15
# while ((iteration < maximum.iterations) && (deriv > stopping.deriv)) {
#   iteration <- iteration + 1
#   mse.1 <- mean(((gmp$pcgmp - 6611*gmp$pop^a)^2))
#   mse.2 <- mean(((gmp$pcgmp - 6611*gmp$pop^(a+deriv.step))^2))
#   deriv <- (mse.2 - mse.1)/deriv.step
#   a <- a - step.scale*deriv
# }
# print(list(a=a,iterations=iteration,converged=(iteration < maximum.iterations)))

# estimate.scaling.exponent.1 (with logic fix for abs(deriv))
estimate.scaling.exponent.1 <- function(a) {
  maximum.iterations <- 100
  deriv.step <- 1/1000
  step.scale <- 1e-12
  stopping.deriv <- 1/100
  iteration <- 0
  deriv <- Inf
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    mse.1 <- mean(((gmp$pcgmp - 6611 * gmp$pop^a)^2))
    mse.2 <- mean(((gmp$pcgmp - 6611 * gmp$pop^(a + deriv.step))^2))
    deriv <- (mse.2 - mse.1) / deriv.step
    a <- a - step.scale * deriv
  }
  fit <- list(a = a, iterations = iteration, converged = (iteration < maximum.iterations))
  return(fit)
}
print(estimate.scaling.exponent.1(0.15))

# estimate.scaling.exponent.2 (with defaults for magic numbers)
estimate.scaling.exponent.2 <- function(a, y0 = 6611,
  maximum.iterations = 100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    mse.1 <- mean(((gmp$pcgmp - y0 * gmp$pop^a)^2))
    mse.2 <- mean(((gmp$pcgmp - y0 * gmp$pop^(a + deriv.step))^2))
    deriv <- (mse.2 - mse.1) / deriv.step
    a <- a - step.scale * deriv
  }
  fit <- list(a = a, iterations = iteration, converged = (iteration < maximum.iterations))
  return(fit)
}
print(estimate.scaling.exponent.2(0.15))

# estimate.scaling.exponent.3 (with nested mse function)
estimate.scaling.exponent.3 <- function(a, y0 = 6611,
  maximum.iterations = 100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  mse <- function(a_local) { mean(((gmp$pcgmp - y0 * gmp$pop^a_local)^2)) }
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    deriv <- (mse(a + deriv.step) - mse(a)) / deriv.step
    a <- a - step.scale * deriv
  }
  fit <- list(a = a, iterations = iteration, converged = (iteration < maximum.iterations))
  return(fit)
}
print(estimate.scaling.exponent.3(0.15))

# estimate.scaling.exponent.4 (with response and predictor arguments)
estimate.scaling.exponent.4 <- function(a, y0 = 6611,
  response = gmp$pcgmp, predictor = gmp$pop,
  maximum.iterations = 100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  mse <- function(a_local) { mean(((response - y0 * predictor^a_local)^2)) }
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    deriv <- (mse(a + deriv.step) - mse(a)) / deriv.step
    a <- a - step.scale * deriv
  }
  fit <- list(a = a, iterations = iteration, converged = (iteration < maximum.iterations))
  return(fit)
}
print(estimate.scaling.exponent.4(0.15))

# estimate.scaling.exponent.5 (using for loop with break)
estimate.scaling.exponent.5 <- function(a, y0 = 6611,
  response = gmp$pcgmp, predictor = gmp$pop,
  maximum.iterations = 100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  mse <- function(a_local) { mean(((response - y0 * predictor^a_local)^2)) }
  for (iteration in 1:maximum.iterations) {
    deriv <- (mse(a + deriv.step) - mse(a)) / deriv.step
    a <- a - step.scale * deriv
    if (abs(deriv) <= stopping.deriv) { break() }
  }
  fit <- list(a = a, iterations = iteration, converged = (iteration < maximum.iterations))
  return(fit)
}
print(estimate.scaling.exponent.5(0.15))

# Predict.plm function
predict.plm <- function(object, newdata) {
  stopifnot("a" %in% names(object), "y0" %in% names(object))
  a <- object$a
  y0 <- object$y0
  stopifnot(is.numeric(a), length(a) == 1)
  stopifnot(is.numeric(y0), length(y0) == 1)
  stopifnot(is.numeric(newdata))
  return(y0 * newdata^a)
}
fitted_model <- estimate.scaling.exponent.5(0.15)
new_data_points <- c(100, 500, 1000, 2000)
predictions <- predict.plm(object = fitted_model, newdata = new_data_points)
print(predictions)

# plot.plm.1 (simple plot function)
plot.plm.1 <- function(plm, from, to) {
  y0 <- plm$y0
  a <- plm$a
  f <- function(x) { return(y0 * x^a) }
  curve(f(x), from = from, to = to)
  invisible(TRUE)
}
# To run this, you need an active plot device. For non-interactive use, save to PDF.
pdf("plot_plm1.pdf", width=7, height=5)
plot(pcgmp ~ pop, data = gmp, log = "x", xlab = "Population", ylab = "Per-Capita Economic Output ($/person-year)", main = "US Metropolitan Areas, 2006")
plot.plm.1(fitted_model, from = min(gmp$pop), to = max(gmp$pop))
dev.off()

# plot.plm.2 (plot function with ... for extra arguments)
plot.plm.2 <- function(plm, ...) {
  y0 <- plm$y0
  a <- plm$a
  f <- function(x) { return(y0 * x^a) }
  curve(f(x), ...)
  invisible(TRUE)
}
pdf("plot_plm2.pdf", width=7, height=5)
plot(pcgmp ~ pop, data = gmp, log = "x", xlab = "Population", ylab = "Per-Capita Economic Output ($/person-year)", main = "US Metropolitan Areas, 2006")
plot.plm.2(fitted_model, from = min(gmp$pop), to = max(gmp$pop), col = "red", lwd = 2)
dev.off()

# plot.plm.3 (plot using predict.plm)
plot.plm.3 <- function(plm, from, to, n = 101, ...) {
  x_vals <- seq(from = from, to = to, length.out = n)
  y_vals <- predict.plm(object = plm, newdata = x_vals)
  plot(x_vals, y_vals, ...)
  invisible(TRUE)
}
pdf("plot_plm3.pdf", width=7, height=5)
plot(pcgmp ~ pop, data = gmp, log = "x", xlab = "Population", ylab = "Per-Capita Economic Output ($/person-year)", main = "US Metropolitan Areas, 2006", type = "p")
plot.plm.3(fitted_model, from = min(gmp$pop), to = max(gmp$pop), col = "green", type = "l", lwd = 2)
dev.off()

# Recursion: Factorial
my.factorial <- function(n) {
  if (n == 1) {
    return(1)
  } else {
    return(n * my.factorial(n - 1))
  }
}
print(my.factorial(5))

# Recursion: Fibonacci
fib <- function(n) {
  if ( (n == 1) || (n == 0) ) {
   return(1)
  } else {
   return (fib(n - 1) + fib(n - 2))
  }
}
print(fib(5))