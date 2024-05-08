library(raster)
library(ggplot2)
library(patchwork)
library(RStoolbox)
library(viridis)
library(GGally) # for ggpairs

#### Calculation of heterogeneity

sent <- brick("/home/duccio/Documents/rao_devst/SENT2_gricilli_2022-07-04.tif")

ggRGB(sent, 8,4,3)
ggRGB(sent, 4,3,2)

#Sentinel bands:
# Sentinel-2 Bands 	Central Wavelength (µm) 	Resolution (m)
# Band 1 - Coastal aerosol 	0.443 	60
# Band 2 - Blue 	0.490 	10
# Band 3 - Green 	0.560 	10
# Band 4 - Red 	0.665 	10
# Band 5 - Vegetation Red Edge 	0.705 	20
# Band 6 - Vegetation Red Edge 	0.740 	20
# Band 7 - Vegetation Red Edge 	0.783 	20
# Band 8 - NIR 	0.842 	10
# Band 8A - Vegetation Red Edge 	0.865 	20
# Band 9 - Water vapour 	0.945 	60
# Band 10 - SWIR - Cirrus 	1.375 	60
# Band 11 - SWIR 	1.610 	20
# Band 12 - SWIR 	2.190 	20

# Sentinel bands:
#Band 2 - Blue
#Band 3 - Green
#Band 4 - Red
#Band 8 - NIR

# B2, B3, B4, B5, B6, B7, B8, B9, B11, B12

# SENTINEL-2 10 m spatial resolution bands: B2 (490 nm), B3 (560 nm), B4 (665 nm) and B8 (842 nm)

# SENTINEL-2 20 m spatial resolution bands: B5 (705 nm), B6 (740 nm), B7 (783 nm), B8a (865 nm), B11 (1610 nm) and B12 (2190 nm)

# SENTINEL-2 60 m spatial resolution bands: B1 (443 nm), B9 (940 nm) and B10 (1375 nm)

# Test with 10m spatial resolution
s10m <- stack(sent$B2, sent$B3, sent$B4, sent$B8)

# Multispectral Rao
rao_ms <- paRao(   x = ms_list,
                   area = NULL,
                   field = NULL,
                   dist_m = "euclidean",
                   window = 3,
                   alpha = 1,
                   method = "multidimension",
                   rasterOut = TRUE,
                   lambda = 0,
                   na.tolerance = 1.0,
                   rescale = FALSE,
                   diag = TRUE,
                   simplify = 1,
                   np = 1,
                   cluster.type = "SOCK",
                   debugging = FALSE
                   )
# NDVI Rao
rao_ndvi <- paRao( x = ndvi,
                   area = NULL,
                   field = NULL,
                   dist_m = "euclidean",
                   window = 3,
                   alpha = 1,
                   method = "classic",
                   rasterOut = TRUE,
                   lambda = 0,
                   na.tolerance = 1.0,
                   rescale = FALSE,
                   diag = TRUE,
                   simplify = 1,
                   np = 1,
                   cluster.type = "SOCK",
                   debugging = FALSE
                   )

#NDVI Standard Deviatiom
ndvi_sd <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)

#### Graphing

focali <- raster("/home/duccio/Documents/rao_devst/gricilli_ndvi_SD.tif")
raoi <- raster("/home/duccio/Documents/rao_devst/gricilli_ndvi_rao.tif")
raomulti <- raster("~/Documents/rao_devst/sent2_rao10m.tif")
# one might also make use of sentinel-2_20m.tif which is the Rao multi with bands at 10m and 20m
# while this is with all bands: gricilli_MultiSpectral_rao.tif and can be useful to simulate a difference
stacki <- stack(focali, raoi, raomulti)
plot(stacki)
# ggplot

# > stacki
# class      : RasterStack
# dimensions : 104, 115, 11960, 3  (nrow, ncol, ncell, nlayers)
# resolution : 10, 10  (x, y)
# extent     : 342610, 343760, 4590480, 4591520  (xmin, xmax, ymin, ymax)
# crs        : +proj=utm +zone=33 +datum=WGS84 +units=m +no_defs
# names      :      layer.1,      layer.2,      layer.3
# min values : 0.0003132602, 0.0000000000, 0.0000000000
# max values : 3.539335e-02 (0.03), 3.259259e-01 (0.3), 3.388592e+03


p1 <- ggplot() +
geom_raster(stacki, mapping =aes(x=x, y=y, fill=layer.1)) +
scale_fill_viridis(option="viridis") +
ggtitle("NDVI standard deviation")

p2 <- ggplot() +
geom_raster(stacki, mapping =aes(x=x, y=y, fill=layer.2)) +
scale_fill_viridis(option="viridis") +
ggtitle("NDVI Rao's Q")

p3 <- ggplot() +
geom_raster(stacki, mapping =aes(x=x, y=y, fill=layer.3)) +
scale_fill_viridis(option="viridis") +
ggtitle("Multispectral Rao's Q")

p1+p2+p3

ggpairs(stacki, columns=3:5)
# fai un crop senza cornice esterna e verrà fuori che il Rao's Q multispettrale da più informazione
# https://r-charts.com/correlation/ggpairs/
ggally_smooth

ggpairs(stacki, columns=3:5, lower = list(continuous = "smooth"))


lowerFn <- function(data, mapping, method = "lm", ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_point(colour = "yellow") +
    geom_smooth(method = method, color = "red", ...)
  p
}

ggpairs(
stacki, columns=3:5,
lower = list(continuous = wrap(lowerFn, method = "lm")),
upper = list(continuous = wrap("cor", size = 10))
)

paramRao <- function(data, mapping, method="loess", ...){
      p <- ggplot(data = data, mapping = mapping) +
      geom_point(colour="light blue") +
      geom_smooth(method=method, ...)
      p
    }

# Default loess curve
ggpairs(
stacki, column=3:5,
lower = list(continuous = paramRao),
upper = list(continuous = wrap("cor", size = 10))
)
# long time needed to make the regression

#-------- crop stacki

ext <- c(342700, 343700, 4590600, 4591300)
stacki.crop <- crop(stacki, ext)
plot(stacki.crop)

# Default loess curve
paramRao <- function(data, mapping, method="loess", ...){
      p <- ggplot(data = data, mapping = mapping) +
      geom_point(colour="light blue") +
      geom_smooth(method=method, ...)
      p
    }

ggpairs(
stacki.crop, column=3:5,
lower = list(continuous = paramRao)
# ,
# upper = list(continuous = wrap("cor"))
)
# long time needed to make the regression

# metti anche il plot dell'immagine originale che prima va tagliata con l'estensione del crop

pdf("corplot.pdf")
ggpairs(
stacki.crop, column=3:5,
lower = list(continuous = paramRao)
# ,
# upper = list(continuous = wrap("cor"))
)
# long time needed to make the regression
dev.off()

######### Sass de Stria test

focalis <- raster("/home/duccio/Documents/rao_devst/sass_de_stria_data/SD_NDVI_sass-de-stria.tif")
raois <- raster("/home/duccio/Documents/rao_devst/sass_de_stria_data/rao_NDVI_sass-de-stria.tif")
raomultis <- raster("~/Documents/rao_devst/sass_de_stria_data/rao_sass-de-stria_10m.tif")

# orginail set
sents <- brick("~/Documents/rao_devst/sass_de_stria_data/SENT2_sass-de-stria_2022-08-21_10m.tif")

stackis <- stack(focalis, raois, raomultis)
plot(stackis)

p01 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="viridis") +
ggtitle("Multispectral Rao")

p02 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="cividis") +
ggtitle("Multispectral Rao")

p03 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="magma") +
ggtitle("Multispectral Rao")

p04 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="plasma") +
ggtitle("Multispectral Rao")

p05 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno") +
ggtitle("Multispectral Rao")

p06 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="mako") +
ggtitle("Multispectral Rao")

p07 <- ggplot() +
geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="rocket") +
ggtitle("Multispectral Rao")

p01 + p02 + p03 + p04 / p05 + p06 + p07

#best: viridis, mako, rocket
p01 + p06 + p07
#viridis wins!

# plot
pp1 <-  ggRGB(sents, 4,3,2)
pp2 <-  ggplot() +
        geom_raster(focalis, mapping =aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="viridis") +
        ggtitle("NDVI Standard deviation")
pp3 <-  ggplot() +
        geom_raster(raomultis, mapping =aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="viridis") +
        ggtitle("NDVI Rao's Q")
pp4 <-  ggplot() +
        geom_raster(raois, mapping =aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="viridis") +
        ggtitle("Multispectral Rao's Q")

pp1 + pp2 + pp3 + pp4

pp2 / pp3 / pp4

# pairs
# paramRao <- function(data, mapping, method="loess", ...){
#       p <- ggplot(data = data, mapping = mapping) +
#       geom_point(colour="light blue") +
#       geom_smooth(method=method, ...)
#       p
#     }

# without standard error
paramRao <- function(data, mapping, method="loess", ...){
      p <- ggplot(data = data, mapping = mapping) +
      geom_point(colour="light blue") +
      geom_smooth(method=method, se = F, ...)
      p
    }

pdf("pairs.pdf")
ggpairs(
stackis, column=3:5,
lower = list(continuous = paramRao)
# ,
# upper = list(continuous = wrap("cor"))
)
# long time needed to make the regression
dev.off()

# metti anche il plot dell'immagine originale che prima va tagliata con l'estensione del crop

# pdf("corplot.pdf")
# ggpairs(
# stacki.crop, column=3:5,
# lower = list(continuous = paramRao)
# # ,
# # upper = list(continuous = wrap("cor"))
# )
# # long time needed to make the regression
# dev.off()

# crop
ext <- c(728000, 732000, 5155000, 5157900)
stackis.crop <- crop(stackis, ext)

# cropped image without standard error
paramRao <- function(data, mapping, method="loess", ...){
      p <- ggplot(data = data, mapping = mapping) +
      geom_point(colour="light blue") +
      geom_smooth(method=method, se = F, ...)
      p
    }

ggpairs(
stackis.crop, column=3:5,
lower = list(continuous = paramRao)
# ,
# upper = list(continuous = wrap("cor"))
)
