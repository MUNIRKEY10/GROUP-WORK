import numpy as np
import matplotlib.pyplot as plt

# 1. Create dummy data
data = np.random.rand(10, 10)

# 2. Generate the heatmap
plt.imshow(data, cmap='viridis')
plt.title('Python Heatmap')
plt.colorbar(label='Value')
plt.show()
