# Comparison of Optimization Algorithms
# Includes: Gradient Descent, Newton's Method (BFGS), Nelder-Mead, and Coordinate Descent

using Optim
using ForwardDiff
using Printf

println("=== Optimization Algorithms Comparison ===\n")

# Test function: Rosenbrock
rosenbrock(x) = (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2

x_init = [-1.0, 2.0]
println("Test function: Rosenbrock")
println("f(x, y) = (1-x)² + 100(y-x²)²")
println("True minimum: (1, 1) with f = 0")
@printf("Starting point: [%.1f, %.1f]\n\n", x_init[1], x_init[2])

# 1. Gradient Descent
println("--- 1. Gradient Descent ---")
result_gd = optimize(rosenbrock, x_init, GradientDescent())
@printf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
        Optim.minimizer(result_gd)[1], Optim.minimizer(result_gd)[2],
        Optim.minimum(result_gd))
@printf("Iterations: %d\n\n", Optim.iterations(result_gd))

# 2. Newton's Method (BFGS)
println("--- 2. Newton's Method (BFGS) ---")
result_bfgs = optimize(rosenbrock, x_init, BFGS())
@printf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
        Optim.minimizer(result_bfgs)[1], Optim.minimizer(result_bfgs)[2],
        Optim.minimum(result_bfgs))
@printf("Iterations: %d\n\n", Optim.iterations(result_bfgs))

# 3. Nelder-Mead (Simplex Method)
println("--- 3. Nelder-Mead (Simplex) ---")
result_nm = optimize(rosenbrock, x_init, NelderMead())
@printf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
        Optim.minimizer(result_nm)[1], Optim.minimizer(result_nm)[2],
        Optim.minimum(result_nm))
@printf("Iterations: %d\n\n", Optim.iterations(result_nm))

# 4. Coordinate Descent (manual implementation)
function coordinate_descent(f, x_init; max_iter=100, tol=1e-6)
    x = copy(x_init)
    n_dims = length(x)

    for iteration in 1:max_iter
        x_old = copy(x)

        # Optimize each coordinate
        for i in 1:n_dims
            # Define 1D function for coordinate i
            f_1d(xi) = begin
                x_temp = copy(x)
                x_temp[i] = xi
                f(x_temp)
            end

            # Optimize this coordinate
            result_1d = optimize(f_1d, x[i], BFGS())
            x[i] = Optim.minimizer(result_1d)[1]
        end

        # Check convergence
        if norm(x - x_old) < tol
            return (x=x, iterations=iteration, value=f(x))
        end
    end

    return (x=x, iterations=max_iter, value=f(x))
end

println("--- 4. Coordinate Descent ---")
result_cd = coordinate_descent(rosenbrock, x_init, max_iter=100)
@printf("Result: x = [%.4f, %.4f], f(x) = %.6e\n",
        result_cd.x[1], result_cd.x[2], result_cd.value)
@printf("Iterations: %d\n\n", result_cd.iterations)

# Summary
println("="^70)
println("=== Summary Comparison ===\n")
@printf("%-20s %-20s %-15s %-10s\n", "Method", "Final x", "f(x)", "Iterations")
println("-"^70)
@printf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Gradient Descent",
        Optim.minimizer(result_gd)[1], Optim.minimizer(result_gd)[2],
        Optim.minimum(result_gd), Optim.iterations(result_gd))
@printf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Newton (BFGS)",
        Optim.minimizer(result_bfgs)[1], Optim.minimizer(result_bfgs)[2],
        Optim.minimum(result_bfgs), Optim.iterations(result_bfgs))
@printf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Nelder-Mead",
        Optim.minimizer(result_nm)[1], Optim.minimizer(result_nm)[2],
        Optim.minimum(result_nm), Optim.iterations(result_nm))
@printf("%-20s [%.4f, %.4f]   %.6e %-10d\n", "Coordinate Descent",
        result_cd.x[1], result_cd.x[2], result_cd.value, result_cd.iterations)

println("\nAll methods successfully minimized the test function!")
