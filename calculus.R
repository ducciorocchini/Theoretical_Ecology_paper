# Script by Michele Torresani

library(rasterdiv)
library(viridis)

rgb<-stack("C:/Users/MicTorresani/Documents/S2A_MSIL2A_20230821T100601_N0509_R022_T32TQS_20230821T163000.SAFE/GRANULE/L2A_T32TQS_A042633_20230821T101414/IMG_DATA/R10m/T32TQS_20230821T100601_TCI_10m.jp2")
ndvi<-raster("C:/Users/MicTorresani/Documents/S2A_MSIL2A_20230821T100601_N0509_R022_T32TQS_20230821T163000.SAFE/GRANULE/L2A_T32TQS_A042633_20230821T101414/IMG_DATA/R10m/ndvi.tif")
shp<-shapefile("C:/Users/MicTorresani/OneDrive - Scientific Network South Tyrol/articoli scritti/On the enticing power of spatial Rao's Q to compute multivariate ecosystem heterogeneity maths and stats/shp/aoi_shp.shp")

ndvi_crop<-crop(ndvi, shp)
rgb_cropped<-crop(rgb,shp)

rao<-paRao(
  ndvi_crop,
  area = NULL,
  field = NULL,
  dist_m = "euclidean",
  window = 9,
  alpha = 1,
  method = "classic")


shannon<-Shannon(
  ndvi_crop,
  window = 9,
  rasterOut = TRUE,
  np = 1,
  na.tolerance = 1,
  cluster.type = "SOCK",
  debugging = FALSE
)

writeRaster(rgb_cropped, "C:/Users/MicTorresani/OneDrive - Scientific Network South Tyrol/articoli scritti/On the enticing power of spatial Rao's Q to compute multivariate ecosystem heterogeneity maths and stats/raster_per_duccio/rgb.tiff" )
writeRaster(rao$window.9$alpha.1, "C:/Users/MicTorresani/OneDrive - Scientific Network South Tyrol/articoli scritti/On the enticing power of spatial Rao's Q to compute multivariate ecosystem heterogeneity maths and stats/raster_per_duccio/rao.tiff" )
writeRaster(shannon, "C:/Users/MicTorresani/OneDrive - Scientific Network South Tyrol/articoli scritti/On the enticing power of spatial Rao's Q to compute multivariate ecosystem heterogeneity maths and stats/raster_per_duccio/shannon.tiff" )
