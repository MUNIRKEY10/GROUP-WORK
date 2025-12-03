# Julia: functions_from_notes.jl
using Statistics
# using Plots

# 1) utilities
cube(x) = x .^ 3  # works elementwise
circle_area(r) = π * (r .^ 2)

function psi_robust(x)
    x = collect(x)
    out = similar(x)
    for i in eachindex(x)
        out[i] = (x[i]^2 > 1) ? (2*abs(x[i]) - 1) : (x[i]^2)
    end
    return out
end

# 2) recursion
function my_factorial(n::Integer)
    n <= 1 && return 1
    return n * my_factorial(n-1)
end

function fib(n::Integer)
    if n == 0 || n == 1
        return 1
    else
        return fib(n-1) + fib(n-2)
    end
end

# 3) power-law fit: linear regression on logs, returns Dict-like object
function fit_power_law(N::AbstractVector, Y::AbstractVector)
    N = collect(Float64, N)
    Y = collect(Float64, Y)
    if any(N .<= 0) || any(Y .<= 0)
        throw(ArgumentError("N and Y must be positive"))
    end
    logN = log.(N)
    logY = log.(Y)
    X = hcat(ones(length(logN)), logN) # least-squares solution
    beta = X \ logY           
    logy0, a = beta[1], beta[2]
    return Dict("a"=>a, "y0"=>exp(logy0), "beta"=>beta)
end

function predict_plm(plm::Dict, newdata)
    a = plm["a"]; y0 = plm["y0"]
    return y0 .* (newdata .^ a)
end

# remove random point and refit
function remove_random_and_refit(N, Y, seed=nothing)
    if seed !== nothing
        Random.seed!(seed)
    end
    idx = rand(1:length(N))
    N2 = deleteat!(collect(N), idx)
    Y2 = deleteat!(collect(Y), idx)
    plm = fit_power_law(N2, Y2)
    return Dict("removed_index"=>idx, "plm"=>plm, "N2"=>N2, "Y2"=>Y2)
end

# Example:
# N = [1,2,5,10,20,50]
# Y = 2.5 .* N .^ 0.8 .* (1 .+ 0.05 .* randn(length(N)))
# plm = fit_power_law(N, Y)
# println(plm)
# ys = predict_plm(plm, range(minimum(N), stop=maximum(N), length=200))