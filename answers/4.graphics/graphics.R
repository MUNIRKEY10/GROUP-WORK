# 1. Create dummy data
data <- matrix(runif(100), nrow = 10)

# 2. Generate the image plot (heatmap)
image(data, 
      main = "R Image Plot (Heatmap)", 
      col = heat.colors(100))
