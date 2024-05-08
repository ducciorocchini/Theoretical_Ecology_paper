# Import data
# Data from Sass de Stria

library(terra)

data(volcano)
r <- terra::rast(volcano)
# we want to compute Rao's index on this data using a 3x3 window
res <- paRao(x = r, window = 3, alpha = 2, method = "classic")
terra::plot(res[[1]][[1]])
