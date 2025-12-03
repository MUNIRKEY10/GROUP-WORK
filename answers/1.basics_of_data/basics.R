# R code for "Basics of Data"

# Arithmetic operators
7 + 5
7 - 5
7 * 5
7 / 5
7 ^ 5
7 %% 5
7 %/% 5

# Comparison operators
7 > 5
7 < 5
7 >= 7
7 <= 5
7 == 5
7 != 5

# Boolean operators
(5 > 7) & (6 * 7 == 42)
(5 > 7) | (6 * 7 == 42)

# Data types
typeof(7)
is.numeric(7)
is.na(7)
is.na(7/0)
is.na(0/0)
is.character(7)
is.character("7")
is.character("seven")
is.na("seven")
as.character(5/6)
as.numeric(as.character(5/6))
6 * as.numeric(as.character(5/6))
5/6 == as.numeric(as.character(5/6))

# Variables
pi
pi * 10
cos(pi)
approx.pi <- 22/7
approx.pi
diameter.in.cubits = 10
approx.pi * diameter.in.cubits
circumference.in.cubits <- approx.pi * diameter.in.cubits
circumference.in.cubits
circumference.in.cubits <- 30
circumference.in.cubits

# Workspace
ls()
objects()
rm("circumference.in.cubits")
ls()

# Vectors
x <- c(7, 8, 10, 45)
x
is.vector(x)
x[1]
x[-4]
weekly.hours <- vector(length=5)
weekly.hours[5] <- 8

# Vector arithmetic
y <- c(-7, -8, -10, -45)
x + y
x * y

# Recycling
x + c(-7, -8)
x^c(1, 0, -1, 0.5)
2 * x

# Pairwise comparisons
x > 9
(x > 9) & (x < 20)

# Vector comparisons
x == -y
identical(x, -y)
identical(c(0.5-0.3, 0.3-0.1), c(0.3-0.1, 0.5-0.3))
all.equal(c(0.5-0.3, 0.3-0.1), c(0.3-0.1, 0.5-0.3))

# Functions on vectors
mean(x)
median(x)
sd(x)
var(x)
max(x)
min(x)
length(x)
sum(x)
sort(x)
summary(x)
any(x > 9)
all(x > 9)

# Addressing vectors
x[c(2, 4)]
x[c(-1, -3)]
x[x > 9]
y[x > 9]
places <- which(x > 9)
places
y[places]

# Named components
names(x) <- c("v1", "v2", "v3", "fred")
names(x)
x[c("fred", "v1")]
names(y) <- names(x)
sort(names(x))
which(names(x) == "fred")

# Floating point numbers
0.45 == 3 * 0.15
0.45 - 3 * 0.15
(0.5 - 0.3) == (0.3 - 0.1)
all.equal(0.5 - 0.3, 0.3 - 0.1)

# Integers
is.integer(7)
as.integer(7)
round(7) == 7
