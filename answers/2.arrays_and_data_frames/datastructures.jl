# Julia code for "More Data Structures"
using LinearAlgebra
using Statistics
using DataFrames
using Plots

# Arrays
x = [7, 8, 10, 45]
x_arr = reshape(x, 2, 2)
println(x_arr)
println(size(x_arr))
println(isa(x_arr, Array))
println(eltype(x_arr))

# Accessing and operating on arrays
println(x_arr[1, 2])
println(x_arr[3])
println(x_arr[:, 2])

# Functions on arrays
println(findall(x_arr .> 9))
y = -x
y_arr = reshape(y, 2, 2)
println(y_arr + x_arr)
println(sum(x_arr, dims=2)) # rowSums
println(mean(x_arr, dims=1)) # colMeans
println(mapslices(mean, x_arr, dims=2))

# Matrices
factory = [40 60; 1 3]
println(isa(factory, Array))
println(isa(factory, Matrix))

# Matrix multiplication
six_sevens = reshape(fill(7, 6), 2, 3)
println(six_sevens)
println(factory * six_sevens)

# Multiplying matrices and vectors
output = [10, 20]
println(factory * output)
println(output' * factory)

# Matrix operators
println(transpose(factory))
println(det(factory))
println(diag(factory))
factory[diagind(factory)] = [35, 4]
println(factory)
factory[diagind(factory)] = [40, 3]
println(diagm(0 => [3, 4]))
println(I(2))
println(inv(factory))
println(factory * inv(factory))

# Solving linear systems
available = [1600, 70]
println(factory \ available)
println(factory * (factory \ available))

# Names in matrices (using DataFrames)
factory_df = DataFrame(factory, :auto)
rename!(factory_df, [:cars, :trucks])



# Lists (using arrays of Any)
my_distribution = ["exponential", 7, false]
println(my_distribution)
println(isa(my_distribution, Array))
println(isa(my_distribution[1], String))
println(my_distribution[2]^2)

# Expanding and contracting lists
push!(my_distribution, 7)
println(my_distribution)
println(length(my_distribution))
resize!(my_distribution, 3)
println(my_distribution)

# Naming list elements (using Dictionaries)
my_distribution_dict = Dict("family" => "exponential", "mean" => 7, "is.symmetric" => false)
println(my_distribution_dict)
println(my_distribution_dict["family"])

# Adding and removing named elements
another_distribution = Dict("family" => "gaussian", "mean" => 7, "sd" => 1, "is.symmetric" => true)
my_distribution_dict["was.estimated"] = false
my_distribution_dict["last.updated"] = "2011-08-30"
delete!(my_distribution_dict, "was.estimated")

# Dataframes
a_matrix = [35 10; 8 4]
a_df = DataFrame(a_matrix, :auto)
rename!(a_df, [:v1, :v2])
a_df.logicals = [true, false]
println(a_df)
println(a_df.v1)
println(a_df[1, :])
println(describe(a_df, :mean))

# Adding rows and columns
push!(a_df, (v1 = -3, v2 = -5, logicals = true))
println(a_df)

# Eigen
eigen_result = eigen(factory)
println(eigen_result.values)
println(eigen_result.vectors)
# println(factory * eigen_result.vectors[:, 2])
# println(eigen_result.values[2] * eigen_result.vectors[:, 2])
println(eigen_result.values[2])


# Example dataframe
states = DataFrame(
    Population = [3615, 365, 2212, 2110, 21198],
    Income = [3624, 6315, 4530, 3378, 5114],
    Illiteracy = [2.1, 1.5, 1.8, 1.9, 1.1],
    Life_Exp = [69.05, 70.55, 70.39, 70.66, 71.71],
    Murder = [15.1, 11.3, 7.8, 10.1, 10.3],
    HS_Grad = [41.3, 66.7, 58.1, 39.9, 62.6],
    Frost = [20, 152, 20, 13, 20],
    Area = [50708, 566432, 113417, 51945, 156361],
    abb = ["AL", "AK", "AZ", "AR", "CA"],
    region = ["South", "West", "West", "South", "West"]
)

println(names(states))
println(first(states, 1))
println(states[1, 3])

println(first(states[:, 3]))
println(first(states.Illiteracy))
println(states[states.region .== "West", :Illiteracy])

println(describe(states, :mean, :median, :std))
states.HS_Grad = states.HS_Grad / 100
println(describe(states, :mean, :median, :std))
states.HS_Grad = 100 * states.HS_Grad


# Plotting
@df states scatter(:Frost, :Illiteracy)
