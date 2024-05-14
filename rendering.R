# Final rendering of Figure 1

library(terra)

# input data
ndvi <- rast("~/Downloads/rgb,tiff")

##########----- moving window: 3x3
shan3 <- rast("~/Downloads/raost/shannon_mw3.tiff")
raoq3 <- rast("~/Downloads/raost/rao_mw3.tiff")

stack3 <- c(ndvi[[1]], shan3, raoq3)
plot(stack3, col=viridis(100))
plot(stack3, col=magma(100))
plot(stack3, col=plasma(100))
plot(stack3, col=inferno(100))
plot(stack3, col=cividis(100))
plot(stack3, col=mako(100))
plot(stack3, col=rocket(100))
##########----- moving window: 3x3

##########----- moving window: 5x5
shan5 <- rast("~/Downloads/raost/shannon_mw5.tiff")
raoq5 <- rast("~/Downloads/raost/rao_mw5.tiff")

stack5 <- c(ndvi[[1]], shan5, raoq5)
plot(stack5, col=viridis(100))
plot(stack5, col=magma(100))
plot(stack5, col=plasma(100))
plot(stack5, col=inferno(100))
plot(stack5, col=cividis(100))
plot(stack5, col=mako(100))
plot(stack5, col=rocket(100))
##########----- moving window: 5x5

##########----- moving window: 7x7
shan7 <- rast("~/Downloads/raost/shannon_mw7.tiff")
raoq7 <- rast("~/Downloads/raost/rao_mw7.tiff")

stack7 <- c(ndvi[[1]], shan7, raoq7)
plot(stack7, col=viridis(100))
plot(stack7, col=magma(100))
plot(stack7, col=plasma(100))
plot(stack7, col=inferno(100))
plot(stack7, col=cividis(100))
plot(stack7, col=mako(100))
plot(stack7, col=rocket(100))
##########----- moving window: 7x7

##########----- moving window: 9x9
shan9 <- rast("~/Downloads/raost/shannon_mw9.tiff")
raoq9 <- rast("~/Downloads/raost/rao_mw9.tiff")

stack9 <- c(ndvi[[1]], shan9, raoq9)
plot(stack9, col=viridis(100))
plot(stack9, col=magma(100))
plot(stack9, col=plasma(100))
plot(stack9, col=inferno(100))
plot(stack9, col=cividis(100))
plot(stack9, col=mako(100))
plot(stack9, col=rocket(100))
##########----- moving window: 9x9












