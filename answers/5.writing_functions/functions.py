# Python: functions_from_notes.py
import math
import random
import numpy as np
import matplotlib.pyplot as plt
from typing import Dict, Sequence

# 1) simple utilities
def cube(x):
    # works with scalars or numpy arrays/lists
    return np.power(np.array(x), 3)

def circle_area(r):
    r = np.array(r, dtype=float)
    return math.pi * r**2

def psi_robust(x):
    x = np.array(x, dtype=float)
    # if x^2 > 1 -> 2*|x| - 1 else x^2  (matches psi.1 from notes)
    return np.where(x**2 > 1, 2*np.abs(x) - 1, x**2)

# 2) recursion examples
def my_factorial(n):
    if n <= 1:
        return 1
    return n * my_factorial(n-1)

def fib(n):
    if n == 0 or n == 1:
        return 1
    return fib(n-1) + fib(n-2)

# 3) Power-law model fitter: Y = y0 * N^a
def fit_power_law(N: Sequence[float], Y: Sequence[float]) -> Dict[str, float]:
    N = np.array(N, dtype=float)
    Y = np.array(Y, dtype=float)
    if any(N <= 0) or any(Y <= 0):
        raise ValueError("N and Y must be positive for log-fit.")
    logN = np.log(N)
    logY = np.log(Y)
    # linear least squares on logs
    A = np.vstack([np.ones_like(logN), logN]).T
    beta, *_ = np.linalg.lstsq(A, logY, rcond=None)
    log_y0, a = beta[0], beta[1]
    return {"a": float(a), "y0": float(math.exp(log_y0))}

def predict_plm(plm: Dict[str,float], newdata):
    newdata = np.array(newdata, dtype=float)
    a = plm["a"]; y0 = plm["y0"]
    return y0 * newdata**a

# helper: plot fitted curve and data
def plot_plm(plm, N, Y, n_points=200, show_points=True):
    x_min, x_max = min(N), max(N)
    xs = np.linspace(x_min, x_max, n_points)
    ys = predict_plm(plm, xs)
    plt.figure()
    if show_points:
        plt.scatter(N, Y, label="data")
    plt.plot(xs, ys, label=f"fit: y0={plm['y0']:.3g}, a={plm['a']:.3g}")
    plt.xscale('log'); plt.yscale('log')
    plt.xlabel("N (log scale)")
    plt.ylabel("Y (log scale)")
    plt.legend()
    plt.show()

# exercise helper: remove one random data point and re-fit
def remove_random_and_refit(N, Y, seed=None):
    if seed is not None:
        random.seed(seed)
    idx = random.randrange(len(N))
    N2 = np.delete(np.array(N), idx)
    Y2 = np.delete(np.array(Y), idx)
    plm = fit_power_law(N2, Y2)
    return {"removed_index": idx, "plm": plm, "N2": N2, "Y2": Y2}

# Example usage:
if __name__ == "__main__":
    N = np.array([1,2,5,10,20,50])
    Y = 2.5 * N**0.8 * (1 + 0.05*np.random.randn(len(N)))
    plm = fit_power_law(N, Y)
    print("fit:", plm)
    plot_plm(plm, N, Y)
    out = remove_random_and_refit(N, Y, seed=1)
    print("removed index:", out["removed_index"], "new fit:", out["plm"])