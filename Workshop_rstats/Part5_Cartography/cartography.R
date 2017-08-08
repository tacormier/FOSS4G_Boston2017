# Learning R: cartography.R
# author: Tina Cormier
# date: August, 2017

# Description: Learn how to make a basic map with R.

library(raster) # raster AND vector analysis
library(rasterVis) # visualization of raster data
library(data.table) # enhanced version of data.frames. FAST.
library(rgdal) # bindings to GDAL (must have gdal installed).
library(ggplot2) 
library(ggmap)
library(rgeos)
library(tmap)

wd <- "/Users/tcormier/Documents/misc_projects/foss4g2017_workshop/data/"
setwd(wd)

# We have already done some of this, but let's make a final map for the course!
# Some files: birds and counties from our rdata file:
rdata <- "birds_counties_extract.RDATA"
# canopy cover img
canopy.file <- "landcover/nlcd2011_usfs_conus_canopy_cover.tif"

# Open rdata file
load(rdata)

# Open the canopy cover layer
cc <- raster(canopy.file)

###########################
# plot a map with county boundaries, basemap on bottom,
# bird points colored by spp on top.
# *** Think about birding density map if time ***

# let's count the number of points in each polygon to see which counties are hotspots
# for birding
count <- over(birds.int, county.ne)

county.latlon <- spTransform(county.ne, "+init=epsg:4326")
county.center <- gCentroid(county.latlon)
# small manual adjustment (after looking at basemap at county.center).
# Wanted to move the map over a touch
county.xy <- c(-71.66031, 44.24661)
# get basemap
ne.map <- get_map(location=xy, zoom=6, maptype = "terrain")
ggmap(ne.map)
m <- ggmap(ne.map)
m + coord_map("conic", lat0 = 30)


tm.map <- tm_shape(birds.int) + tm_dots(col="COMMON.NAME") +
  tm_shape(county.ne) + tm_polygons() + tm_fill(col=NA)
  tm_compass() + tm_scale_bar
  
p.test <- ggplot(data=birds.int@data, aes(canopy_cover, imp_surface)) + geom_point()

plist <- list(tm.map, p.test)  
library(gridExtra)

#output as PDF
pdf("multipage.pdf")

#use gridExtra to put plots together
grid.arrange(tm.map, p.test, ncol=2)
dev.off()  



data(land, rivers, metro)
  
  tm_shape(land) + 
    tm_raster("trees", breaks=seq(0, 100, by=20), legend.show = FALSE) +
    tm_shape(Europe, is.master = TRUE) +
    tm_borders() +
    tm_shape(rivers) +
    tm_lines(lwd="strokelwd", scale=5, legend.lwd.show = FALSE) +
    tm_shape(metro) +
    tm_bubbles("pop2010", "red", border.col = "black", border.lwd=1, 
               size.lim = c(0, 11e6), sizes.legend = c(1e6, 2e6, 4e6, 6e6, 10e6), 
               title.size="Metropolitan Population") +
    tm_text("name", size="pop2010", scale=1, root=4, size.lowerbound = .6, 
            bg.color="white", bg.alpha = .75, 
            auto.placement = 1, legend.size.show = FALSE) + 
    tm_format_Europe() +
    tm_style_natural()

