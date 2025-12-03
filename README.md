# Statistical Computing and Reporting - Code Examples

## Overview

This repository contains Python, R, and Julia implementations of key concepts from 19 chapters of Statistical Computing and Reporting lessons.

## Structure

Each chapter folder (e.g., `7.Distributions/`, `8.Optimisation_1/`) contains:
- `.py` files - Python implementations
- `.R` files - R implementations
- `.jl` files - Julia implementations

## Chapters Covered

### ✅ Completed

1. **Chapter 1-6**: Basics (completed previously)
2. **Chapter 7: Distributions** - Comprehensive coverage including:
   - Random number generation
   - Linear congruential generators
   - Distribution functions (d, p, q, r)
   - Method of moments estimation
   - Maximum likelihood estimation
   - Cat heart analysis example
   - Goodness of fit tests (QQ plots, K-S test)
   - Calibration plot function
   - Chi-squared tests

3. **Chapter 8: Optimisation 1**
   - Gradient descent implementation
   - Comparison of optimization algorithms (GD, Newton, Nelder-Mead, Coordinate Descent)

4. **Chapter 9: Optimisation 2**
   - Constrained optimization with bounds
   - Linear and nonlinear constraints
   - Penalty methods

5. **Chapter 10: Simulation**
   - Distribution simulation (Normal, Exponential, Binomial, Poisson, Uniform)
   - Four distribution functions (pdf, cdf, quantile, random)

6. **Chapter 11: Monte Carlo Simulations**
   - Estimating expectations using Law of Large Numbers
   - Monte Carlo integration
   - Estimating π
   - Convergence visualization

7. **Chapter 12: Bootstrap**
   - Nonparametric bootstrap
   - Parametric bootstrap
   - Confidence intervals via percentile method
   - Bootstrap for various statistics (mean, median, std)

### 🔄 In Progress

8. **Chapter 13: Cross Validation**
9. **Chapter 14: Density Estimation**
10. **Chapter 15: Bayesian Statistics**
11. **Chapter 16: Markov Chain Monte Carlo I**
12. **Chapter 17: Markov Chain Monte Carlo II**
13. **Chapter 18: Permutation Tests**
14. **Chapter 19: Databases**

## Running the Code

### Python
```bash
python filename.py
```
Requirements: `numpy`, `scipy`, `matplotlib`, `pandas`

### R
```bash
Rscript filename.R
```
or in R console: `source("filename.R")`

### Julia
```bash
julia filename.jl
```
Requirements: Install packages with `using Pkg; Pkg.add("PackageName")`

## Key Concepts by Chapter

| Chapter | Main Topics |
|---------|-------------|
| 7 | Probability distributions, estimation, goodness-of-fit |
| 8 | Unconstrained optimization algorithms |
| 9 | Constrained optimization, Lagrange multipliers |
| 10 | Simulation from distributions |
| 11 | Monte Carlo methods, integration |
| 12 | Bootstrap resampling, confidence intervals |
| 13 | Cross-validation for model selection |
| 14 | Kernel density estimation |
| 15 | Bayesian inference |
| 16-17 | MCMC methods (Metropolis-Hastings, Gibbs) |
| 18 | Permutation and randomization tests |
| 19 | Database operations |

## Notes

- Each file is self-contained with examples and visualizations where appropriate
- Code focuses on the main talking points from each chapter
- Maximum 2 example files per chapter (6 files total including all 3 languages)
- All code includes comments explaining key concepts
