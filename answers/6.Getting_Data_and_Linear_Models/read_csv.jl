using CSV
using DataFrames

# Load the data from a CSV file into a DataFrame
data_frame = CSV.read("data.csv", DataFrame)

# Display the first few rows
first(data_frame, 5)
