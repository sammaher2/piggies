#Piggies
#111/14/2018

#libraries
library('sp')
library('rgdal')
library('raster')
library('rasterVis')
library('ggplot2')
library('tiff')
library('rgeos')
library('sf')
library(rprojroot)
library(GADMTools)
library(RColorBrewer)
library(classInt)
library(viridis)
library(maps)

#Set working directory
P <- rprojroot::find_rstudio_root_file

#Load piggy data
pigs <- raster(P("data/worldpig.tif"))

#load china data
china <- readRDS(P("data/gadm36_CHN_1_sp.rds"))
chinaprov <- readRDS(P("data/gadm36_CHN_0_sp.rds"))

#Process pig data 
hist(sampleRegular(pigs, 1000))
chinesepigs <- crop(pigs, china)
chinesepigs <- mask(chinesepigs, china)
writeRaster(chinesepigs, P("data/chinesepigs.tif"))


#plot chinese pigs