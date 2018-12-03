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
china <- readRDS(P("data/gadm36_CHN_0_sp.rds"))
chinaprov <- readRDS(P("data/gadm36_CHN_1_sp.rds"))
#pigs <- projectRaster(from = pigs, to = chinesepigs, over = TRUE)

#Process pig data 
hist(sampleRegular(chinesepigs, 1000))
#chinesepigs <- crop(pigs, china)
#chinesepigs <- mask(chinesepigs, china)
#writeRaster(chinesepigs, P("data/chinesepigs.tif"))
chinesepigs <- raster(P("data/chinesepigs.tif"))
chinesepigs[chinesepigs <= 0] <- 999999
chinesepigs[chinesepigs < 999999] <- 0
chinesepigs[chinesepigs >= 999999] <- 1
nopigs <- chinesepigs
NAvalue(nopigs) <- 0


chinesepigs <- raster(P("data/chinesepigs.tif"))
chinesepigs[chinesepigs >= 50000] <- 50000
chinesepigs2 <- chinesepigs
chinesepigs2[chinesepigs2 >= 20000] <- 20000

pigs[pigs >= 10000] <- 10000 
pigs2 <-pigs
pigs2[pigs2 >= 5000] <- 5000

red2green <- rev(brewer.pal(11, "RdYlGn"))
meh2 <- colorRampPalette(red2green)
meow2 <- meh2(100)

meh3 <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
meow3 <- meh3(100)

color <- colorRampPalette(c("black", "#070764", "blue", "#12ECF3", "#0DC27B",'#12F31C', "#CAF40A", 'yellow'))(20)
meh4 <- colorRampPalette(color)
meow4 <- meh3(100)

color2 <- colorRampPalette(c("black", "blue", "green", "yellow"))(10)
meh5 <- colorRampPalette(color2)
meow5 <- meh5(100)

zClass <- classIntervals(na.omit(sampleRegular(chinesepigs, 10000)), n = 6, style="jenks")

vdis <- viridis(50, 1, begin = 0, end = 1, direction = 1)
magma <- magma(50, 1, begin = 0, end = 1, direction = 1)
civ <- cividis(50, 1, begin = 0, end = 1, direction = 1)
inf <- inferno(50, 1, begin = 0, end = 1, direction = 1)


plot(chinesepigs2, main = "",
     yaxt = "n",
     xaxt = "n",
     bty = "n",
     #breaks = zClass$brks,
     col = inf,
     border = NA,
     box = FALSE
      #legend = FALSE,
    # addfun = plot(chinesepigs, add = TRUE, legend = TRUE, col = inf)
     )
#check
inf2 <- inferno(50, 1, begin = 0, end = 1, direction = 1)
plot(pigs2, main = "",
     yaxt = "n",
     xaxt = "n",
     bty = "n",
     #breaks = zClass$brks,
     col = inf,
     #border = NA,
     box = FALSE,
     legend = TRUE
     #addfun = plot(chinesepigs, add = TRUE, legend = TRUE, col = inf)
)






spp_rich_spdf <- as(sum_stack_list_raster, "SpatialPixelsDataFrame")
stack_list_raster <- as.data.frame(spp_rich_spdf)
zClass <- classIntervals(na.omit(sampleRegular(sum_stack_list_raster, 1000)), n = 11, style = "jenks")   
zClass$brks[1] <- zClass$brks[1] - 1 
ggplot() +  
  geom_raster(data=stack_list_raster, aes(x = x, y = y, fill = layer)) +
  scale_fill_viridis(breaks = zClass$brks, n = 11) +
  coord_equal() +
  theme_map() +
  theme(legend.position = "bottom") +
  theme(legend.key.width = unit(2, "cm")) 









