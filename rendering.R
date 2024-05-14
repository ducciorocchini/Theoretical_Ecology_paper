# Final rendering of Figure 1

library(terra)

ndvi <- rast("~/Downloads/rgb,tiff")
shan <- rast("~/Downloads/rao.tiff")
raoq <- rast("~/Downloads/shannon.tiff")

stack <- c(ndvi, shan, raoq)
plot(stack, col=viridis(100))


