# Python code for "Control Flow and Strings"
import numpy as np

# if()
x = -5
if x >= 0:
  print(x)
else:
  print(-x)

print(x if x >= 0 else -x)

# nested if
if x**2 < 1:
  print(x**2)
else:
  if x >= 0:
    print(2 * x - 1)
  else:
    print(-2 * x - 1)

# Combining Booleans
# In Python, and is the equivalent of && and is also lazy
(0 > 0) and (np.allclose(42 % 6, 169 % 13))

# for()
table_of_logarithms = np.zeros(7)
for i in range(len(table_of_logarithms)):
  table_of_logarithms[i] = np.log(i+1) # add 1 because python is 0-indexed
print(table_of_logarithms)

# while()
x = 100
while np.max(x) - 1 > 1e-06:
  x = np.sqrt(x)

# ifelse() (using np.where)
x = np.arange(-5, 6)
np.where(x**2 > 1, 2 * np.abs(x) - 1, x**2)

# switch() (using a dictionary)
type_of_summary = "mean"
# a manual implementation of switch
def switch(summary_type):
    if summary_type == "mean":
        return np.mean(np.random.rand(10))
    elif summary_type == "median":
        return np.median(np.random.rand(10))
    else:
        return "I don't understand"
print(switch(type_of_summary))


# Strings
len("Lincoln")
"Christmas Bonus"[7:12]
phrase = "Christmas Bonus"
phrase = phrase[:12] + "g" + phrase[13:]
print(phrase)

presidents = ["Fillmore", "Pierce", "Buchanan", "Davis", "Johnson"]
[p[:2] for p in presidents]
[p[-2:] for p in presidents]

scarborough_fair = "parsley, sage, rosemary, thyme"
scarborough_fair.split(", ")

["{} {}".format(p, i) for p, i in zip(presidents, range(41, 46))]
["{}({})".format(p, i) for p, i in zip(presidents, range(41, 46))]
"; ".join(["{}({})".format(p, i) for p, i in zip(presidents, range(41, 46))])
