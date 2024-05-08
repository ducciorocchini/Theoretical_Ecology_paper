# Import data
# Data from Sass de Stria

library(terra)
library(rasterdiv)
library(viridis)

# loading data
sass <- rast("~/Downloads/sass.jpg")

#crop 
ext <- c(50,100,100,150)
sassc <- crop(sass, ext)

# theoretical data
# td <- matrix(runif(100), nrow = 10)
# plot(rast(td))
     
# Shannon
sha <- ShannonP(sassc, window=1, np=1)
plot(sha)

# Shannon
shannon <- Shannon(x=sassc,window=3)

# Rao
res <- paRao(x=sassc, window=3, alpha=3, method = "classic")
plot(res[[1]][[1]], col=viridis(100))

# stack
stack <- c(shannon[[1]][[1]],res[[1]][[1]])
plot(stack, col=viridis(100))
