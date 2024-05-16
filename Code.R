# Import data
# Data from Sass de Stria

library(terra)
library(rasterdiv)
library(viridis)

# loading data
sass <- rast("~/Documents/rao_devst/sass.jpg")
sent <- rast("~/Documents/rao_devst/sentinel-2_20m.tif")

#crop 
ext <- c(50,250,100,300)
sassc <- crop(sass, ext)

# theoretical data
# td <- matrix(runif(100), nrow = 10)
# plot(rast(td))
     
# Shannon
shannon <- Shannon(x=sassc, window=3)

# Rao
res <- paRao(x=sassc, window=3, alpha=3, method = "classic")
plot(res[[1]][[1]], col=viridis(100))

# stack
stack <- c(shannon[[1]][[1]],res[[1]][[1]])
plot(stack, col=viridis(100))

# Sentinel data
# Shannon
shannon <- Shannon(x=sent, window=3)

# Rao
res <- paRao(x=sent, window=3, alpha=3, method = "classic")
plot(res[[1]][[1]], col=viridis(100)) # thanks to my students Irene and Pietro

# stack
stack <- c(shannon[[1]][[1]],res[[1]][[1]])
plot(stack, col=viridis(100))

