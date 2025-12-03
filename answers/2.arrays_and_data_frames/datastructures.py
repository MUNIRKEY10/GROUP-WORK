# Python code for "More Data Structures"
import numpy as np
import pandas as pd
from scipy import linalg

# Arrays
x = np.array([7, 8, 10, 45])
x_arr = x.reshape((2, 2))
print(x_arr)
print(x_arr.shape)
print(isinstance(x_arr, np.ndarray))
print(x_arr.dtype)

# Accessing and operating on arrays
print(x_arr[0, 1])
print(x_arr.flatten()[2])
print(x_arr[:, 1])

# Functions on arrays
print(np.where(x_arr > 9))
y = -x
y_arr = y.reshape((2, 2))
print(y_arr + x_arr)
print(np.sum(x_arr, axis=1)) # rowSums
print(np.mean(x_arr, axis=0)) # colMeans
print(np.apply_along_axis(np.mean, 1, x_arr))

# Matrices
factory = np.matrix([[40, 60], [1, 3]])
print(isinstance(factory, np.ndarray))
print(isinstance(factory, np.matrix))

# Matrix multiplication
six_sevens = np.matrix(np.repeat(7, 6)).reshape(2,3)
print(six_sevens)
print(factory * six_sevens)

# Multiplying matrices and vectors
output = np.array([10, 20])
print(factory * output.reshape(2,1))

# Matrix operators
print(factory.T) # transpose
print(linalg.det(factory))
print(np.diag(factory))
np.fill_diagonal(factory, [35, 4])
print(factory)
np.fill_diagonal(factory, [40, 3])
print(np.diag([3, 4]))
print(np.identity(2))
print(linalg.inv(factory))
print(factory * linalg.inv(factory))

# Solving linear systems
available = np.array([1600, 70])
print(linalg.solve(factory, available))

# Names in matrices (using pandas)
factory_df = pd.DataFrame(factory, index=["labor", "steel"], columns=["cars", "trucks"])
print(factory_df)
available_s = pd.Series(available, index=["labor", "steel"])
output_s = pd.Series([20, 10], index=["trucks", "cars"])
print(factory_df.dot(output_s[factory_df.columns]))


# Lists
my_distribution = ["exponential", 7, False]
print(my_distribution)
print(isinstance(my_distribution, list))
print(isinstance(my_distribution[0], str))
print(my_distribution[1]**2)

# Expanding and contracting lists
my_distribution.append(7)
print(my_distribution)
print(len(my_distribution))
my_distribution = my_distribution[:3]
print(my_distribution)

# Naming list elements (using dictionaries)
my_distribution_dict = {"family": "exponential", "mean": 7, "is.symmetric": False}
print(my_distribution_dict)
print(my_distribution_dict["family"])

# Adding and removing named elements
another_distribution = {"family": "gaussian", "mean": 7, "sd": 1, "is.symmetric": True}
my_distribution_dict["was.estimated"] = False
my_distribution_dict["last.updated"] = "2011-08-30"
del my_distribution_dict["was.estimated"]

# Dataframes
a_matrix = np.array([[35, 10], [8, 4]])
a_df = pd.DataFrame(a_matrix, columns=["v1", "v2"])
a_df["logicals"] = [True, False]
print(a_df)
print(a_df["v1"])
print(a_df.loc[0])
print(a_df.mean())

# Adding rows and columns
a_df.loc[2] = [-3, -5, True]
print(a_df)

# Structures of Structures
plan = {"factory": factory_df, "available": available_s, "output": output_s}
print(plan["output"])

# Eigen
eigenvalues, eigenvectors = linalg.eig(factory)
print(eigenvalues)
print(eigenvectors)
# print(factory.dot(eigenvectors[:, 1])) # dot product requires numpy array, not matrix
# print(eigenvalues[1] * eigenvectors[:, 1])
print(eigenvalues[1])

# Example dataframe
data = {'Population': [3615, 365, 2212, 2110, 21198],
        'Income': [3624, 6315, 4530, 3378, 5114],
        'Illiteracy': [2.1, 1.5, 1.8, 1.9, 1.1],
        'Life.Exp': [69.05, 70.55, 70.39, 70.66, 71.71],
        'Murder': [15.1, 11.3, 7.8, 10.1, 10.3],
        'HS.Grad': [41.3, 66.7, 58.1, 39.9, 62.6],
        'Frost': [20, 152, 20, 13, 20],
        'Area': [50708, 566432, 113417, 51945, 156361],
        'abb': ['AL', 'AK', 'AZ', 'AR', 'CA'],
        'region': ['South', 'West', 'West', 'South', 'West']}
states = pd.DataFrame(data)
print(states.columns)
print(states.head(1))
print(states.iloc[0, 2]) # by integer location
# print(states.loc[0, 'Illiteracy']) # by label
# print(states.loc[0, :])
print(states.iloc[:, 2].head())
print(states['Illiteracy'].head())
print(states[states['region'] == 'West']['Illiteracy'])

print(states['HS.Grad'].describe())
states['HS.Grad'] = states['HS.Grad'] / 100
print(states['HS.Grad'].describe())
states['HS.Grad'] = 100 * states['HS.Grad']

print((100 * (states['HS.Grad'] / (100 - states['Illiteracy']))).head())

import matplotlib.pyplot as plt
states.plot.scatter(x='Frost', y='Illiteracy')
plt.show()
