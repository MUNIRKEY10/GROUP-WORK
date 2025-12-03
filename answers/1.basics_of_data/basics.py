# Python code for "Basics of Data"
import numpy as np

# Arithmetic operators
7 + 5
7 - 5
7 * 5
7 / 5
7 ** 5
7 % 5
7 // 5

# Comparison operators
7 > 5
7 < 5
7 >= 7
7 <= 5
7 == 5
7 != 5

# Boolean operators
(5 > 7) and (6 * 7 == 42)
(5 > 7) or (6 * 7 == 42)

# Data types
type(7)
isinstance(7, (int, float))
np.isnan(7)
np.isnan(7/0) # infinity
np.isnan(0/0)
isinstance(7, str)
isinstance("7", str)
isinstance("seven", str)

str(5/6)
float(str(5/6))
6 * float(str(5/6))
5/6 == float(str(5/6))

# Variables
import math
math.pi
math.pi * 10
math.cos(math.pi)
approx_pi = 22/7
approx_pi
diameter_in_cubits = 10
approx_pi * diameter_in_cubits
circumference_in_cubits = approx_pi * diameter_in_cubits
circumference_in_cubits
circumference_in_cubits = 30
circumference_in_cubits


del circumference_in_cubits


# Vectors (using numpy arrays)
x = np.array([7, 8, 10, 45])
x
isinstance(x, np.ndarray)
x[0] # Python is 0-indexed

weekly_hours = np.zeros(5)
weekly_hours[4] = 8


# Vector arithmetic
y = np.array([-7, -8, -10, -45])
x + y
x * y

# Recycling (broadcasting in numpy)
x + np.array([-7, -8, -7, -8]) # broadcasting is more explicit
x**np.array([1, 0, -1, 0.5])
2 * x

# Pairwise comparisons
x > 9
(x > 9) & (x < 20)

# Vector comparisons
np.array_equal(x, -y)
np.allclose(np.array([0.5-0.3, 0.3-0.1]), np.array([0.3-0.1, 0.5-0.3]))


# Functions on vectors
np.mean(x)
np.median(x)
np.std(x)
np.var(x)
np.max(x)
np.min(x)
len(x)
np.sum(x)
np.sort(x)
np.any(x > 9)
np.all(x > 9)

# Addressing vectors
x[[1, 3]] # 0-indexed

x[x > 9]
y[x > 9]
places = np.where(x > 9)
places
y[places]

# Named components (using pandas Series)
import pandas as pd
x_series = pd.Series([7, 8, 10, 45], index=["v1", "v2", "v3", "fred"])
x_series
x_series[["fred", "v1"]]
y_series = pd.Series([-7, -8, -10, -45], index=x_series.index)
np.sort(x_series.index)
np.where(x_series.index == "fred")

# Floating point numbers
0.45 == 3 * 0.15
0.45 - 3 * 0.15
(0.5 - 0.3) == (0.3 - 0.1)
np.allclose(0.5 - 0.3, 0.3 - 0.1)

# Integers
isinstance(7, int)
int(7)
round(7) == 7
