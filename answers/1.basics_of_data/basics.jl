# Julia code for "Basics of Data"

# Arithmetic operators
7 + 5
7 - 5
7 * 5
7 / 5
7 ^ 5
7 % 5
div(7, 5)

# Comparison operators
7 > 5
7 < 5
7 >= 7
7 <= 5
7 == 5
7 != 5

# Boolean operators
(5 > 7) && (6 * 7 == 42)
(5 > 7) || (6 * 7 == 42)

# Data types
typeof(7)
isa(7, Number)
isnan(7)
isnan(7/0) # infinity
isnan(0/0)
isa(7, String)
isa("7", String)
isa("seven", String)

string(5/6)
parse(Float64, string(5/6))
6 * parse(Float64, string(5/6))
5/6 == parse(Float64, string(5/6))

# Variables
pi
pi * 10
cos(pi)
approx_pi = 22/7
approx_pi
diameter_in_cubits = 10
approx_pi * diameter_in_cubits
circumference_in_cubits = approx_pi * diameter_in_cubits
circumference_in_cubits
circumference_in_cubits = 30
circumference_in_cubits


# Vectors
x = [7, 8, 10, 45]
x
isa(x, Vector)
x[1] # Julia is 1-indexed
x[1:end-1] # To exclude the last element
weekly_hours = zeros(5)
weekly_hours[5] = 8


# Vector arithmetic
y = [-7, -8, -10, -45]
x + y
x .* y 

# Recycling (broadcasting in Julia)
# x + [-7, -8] # This would throw an error
x .+ [-7, -8, -7, -8] # broadcasting is explicit
x .^ [1, 0, -1, 0.5]
2 .* x

# Pairwise comparisons
x .> 9
(x .> 9) .& (x .< 20)

# Vector comparisons
x == -y
x ≈ -y # for floating point comparison
[0.5-0.3, 0.3-0.1] == [0.3-0.1, 0.5-0.3]
[0.5-0.3, 0.3-0.1] ≈ [0.3-0.1, 0.5-0.3]

# Functions on vectors
using Statistics
mean(x)
median(x)
std(x)
var(x)
maximum(x)
minimum(x)
length(x)
sum(x)
sort(x)

any(x .> 9)
all(x .> 9)

# Addressing vectors
x[[2, 4]] # 1-indexed

x[x .> 9]
y[x .> 9]
places = findall(x .> 9)
places
y[places]

# Named components (using Dictionaries)
x_dict = Dict("v1" => 7, "v2" => 8, "v3" => 10, "fred" => 45)
x_dict
x_dict["fred"]
x_dict["v1"]
y_dict = Dict("v1" => -7, "v2" => -8, "v3" => -10, "fred" => -45)
sort(collect(keys(x_dict)))
findall(x -> x == "fred", collect(keys(x_dict)))


# Floating point numbers
0.45 == 3 * 0.15
0.45 - 3 * 0.15
(0.5 - 0.3) == (0.3 - 0.1)
(0.5 - 0.3) ≈ (0.3 - 0.1)

# Integers
isa(7, Int)
convert(Int, 7)
round(7) == 7
