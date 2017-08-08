# Learning R: rasterProcessing.R
# author: Tina Cormier
# date: August, 2017

# Description: Learn how to do basic geoprocessing and visualization with raster files.

######################################
library(raster) # raster AND vector analysis
library(rasterVis) # visualization of raster data
library(data.table) # enhanced version of data.frames. FAST.
library(rgdal) # bindings to GDAL (must have gdal installed).
library(ggplot2) # a plotting system in R (much NICER than base plotting)
library(gdalUtils) # 
######################################

# Time to stop hard coding everything in the body of the code. 
# We'll list our user-input variables up here at the top and build from those.
# What is our current working directory?
getwd()
# Let's set a new one!
wd <- "/Users/tcormier/Documents/misc_projects/foss4g2017_workshop/data/"
setwd(wd) # I don't typically do this, and I'll explain why! But it's easier for this example, and you should know about it!

# User variables
# rdata file containing some variables from our previous session
rdata <- "birds_counties.RDATA"
# canopy cover img
canopy.file <- "landcover/nlcd2011_usfs_conus_canopy_cover.tif"
# impervious surface img
imp.file <- "landcover/nlcd_2011_impervious_2011_edition_2014_10_10.tif"
# landsat directory - just one tile
ls.dir <- "/Users/tcormier/Documents/misc_projects/foss4g2017_workshop/data/LC08_L1TP_013030_20160704_20170222_01_T1/"

# Goal: We'd like to understand a little bit about where we tend to find birds of certain species.

# 1. Open some layers
# Open rdata file
load(rdata)
ls() # what objects are in the global environment? Look! birds.int and county.ne from our last script!

# Open the canopy cover layer
cc <- raster(canopy.file) 

# impervious surfaces
imp <- raster(imp.file)
# Inspect the new datasets (histograms, plots, quick maps)
cc
# lc
imp
# quick plot - we'll work on styling later!
plot(cc) 
# plot(lc)
plot(imp)

# let's assign an NA value and try plotting again (we know the NA value from knowing the data, looking in qgis, gdalinfo etc.)
# When the layer was created, NAvalue wasn't defined for some reason, but we can define it.
NAvalue(cc) <- 255
# plot again
plot(cc)

# How about our points on top? Quick and dirty = not pretty
system.time(plot(birds.int, col="blue", pch=19, cex=0.7, add=T))

NAvalue(imp) <- 127
plot(imp)

# Projection check:
projection(cc)
# projection(lc)
projection(imp)
projection(county.ne)

# Excellent! Same projection. But if we had to project cc to match our county polygons,
# this is how we'd do it. projectRaster will automatically work in parallel if you start
# a cluster. It may still be slower than gdal with -m flag. This can be a time consuming step,
# so we won't do it today, but here's the code.
# beginCluster()
# cc.proj <- projectRaster(cc, crs=projection(county.ne))
# endCluster()


# For a moment we'll work just on a subset of the larger raster:
# Clip the raster to one county in our shapefile. When the raster is much larger in extent than my clip polygon (or raster),
# I usually do this in two steps to make it faster. 1. crop to polygon layer (just crops to extent);
# 2. mask by same polygon, which actually extracts the shape of the polygon. 
# for the sake of speed today, we'll work just with one of the most interesting counties in Massachusetts.
barn <- county.ne[county.ne$NAME_1 == "Massachusetts" & county.ne$NAME_2 == "Barnstable",]
system.time(cc.crop <- crop(cc, barn)) # you can use system.time() to time a process.
plot(barn)
# the masking can be done in parallel
beginCluster()
system.time(cc.mask <- clusterR(cc.crop, mask, args=list(mask=barn)))
endCluster()
plot(cc.mask)


# ALSO SHOW HOW TO BUFFER THE POINTS AND EXTRACT THE MEAN VALUE
# Extract raster values to points - want to know the %canopy cover and %impervious surface
# at each point. Let's go back to the bigger data set and work in parallel!
beginCluster()
system.time(birds.int$canopy_cover <- extract(cc, birds.int))
system.time(birds.int$imp_surface <- extract(imp, birds.int))
endCluster()

# Now let's see what we got
head(birds.int)
summary(birds.int)

# Cool! Now let's REALLY see what it looks like. Start basic with canopy cover:
hist(birds.int$canopy_cover, breaks=20)
# Density plot
hist(birds.int$canopy_cover, freq=F)

# now let's try it with ggplot
ggplot(birds.int@data, aes(canopy_cover)) + geom_histogram(binwidth = 3) # basic
ggplot(birds.int@data, aes(canopy_cover, fill=COMMON.NAME)) + geom_histogram(binwidth = 3) # stack based on species
ggplot(birds.int@data, aes(canopy_cover, fill=COMMON.NAME)) + geom_density() # smoothed kernel density plot ... hmm.
ggplot(birds.int@data, aes(canopy_cover, color=COMMON.NAME)) + geom_density() # smoothed density plot OR
ggplot(birds.int@data, aes(canopy_cover, fill=COMMON.NAME, color=COMMON.NAME)) + geom_density(alpha=0.1) # smoothed density plot
# Add some labels?
p <- ggplot(birds.int@data, aes(canopy_cover, fill=COMMON.NAME, color=COMMON.NAME)) + 
  geom_density(alpha=0.1) + xlab("% Canopy Cover") + title("Species Distribution by Canopy Cover") +
  scale_fill_discrete(name="Common Name") + scale_color_discrete(name="Common Name") # These two are just to change the legend title.
p

# What if we want a different plot per species?
p + facet_wrap(~COMMON.NAME) 
# or species on same plot, but by state?
p + facet_wrap(~STATE_PROVINCE, ncol=3)
# or = grid of x by y
p + facet_grid(STATE_PROVINCE ~ COMMON.NAME)

# Ok, let's say we like this last one and want to save it. There are two ways:
# 1. ggsave will attempt to save your last plot (unless you define a different one) with sensible defaults.
ggsave("birds_densityPlot.png") # will save to your working directory unless you specify a path.

# 2. Open a graphics device and save. First, need to set your plot to a variable
p <- ggplot(birds.int@data, aes(canopy_cover, fill=COMMON.NAME, color=COMMON.NAME)) + 
  geom_density(alpha=0.1) + xlab("% Canopy Cover") + title("Species Distribution by Canopy Cover") +
  scale_fill_discrete(name="Common Name") + scale_color_discrete(name="Common Name")
# Anything I plot or print underneath this command will go to the pdf device rather than the interactive plot window
# or the console.
pdf("birds_density.pdf", width=6.5, height=5) 
print(p)
dev.off() # Be sure to turn off your device

# Box plot of canopy cover by species
ggplot(birds.int@data, aes(x=as.character(year), y=imp_surface, fill=COMMON.NAME)) + geom_boxplot(outlier.shape=1) 
# Wow, those outliers are distracint and actually a small % of the data! Let's not show them.
imp.p <- ggplot(birds.int@data, aes(x=as.character(year), y=imp_surface, fill=COMMON.NAME)) + geom_boxplot(outlier.shape=NA)
cc.p <- ggplot(birds.int@data, aes(x=as.character(year), y=canopy_cover, fill=COMMON.NAME)) + geom_boxplot(outlier.shape=NA)

plot(imp.p)
plot(cc.p)

# Hmm, maybe the canopy cover might tell a better story if we classified the image
# from a continous layer into a thematic layer? You can easily classify images in R. Of course,
# we could just relcassify the values we extracted to our bird points, but that's no fun!
beginCluster()
# note, if this was a more complex reclassification, we could create a 3-column matrix
# to pass to the rcl argument. This will take a few minutes! c(0,2,1,  2,5,2, 4,10,3)
system.time(cc.reclass <- clusterR(cc, reclassify, args=list(rcl=c(0,30,1, 30,60,2, 60,100,3))))
plot(cc.reclass)

# Extract values to points again:
birds.int$canopy_class <- extract(cc.reclass, birds.int)
endCluster()

# Pause to write birds.int (with our extracted rasters) and county.ne to rdata file.
save(birds.int, county.ne, file="/Users/tcormier/Documents/misc_projects/foss4g2017_workshop/data/birds_counties_extract.RDATA")

# Bar plot!
ggplot(data=birds.int@data, aes(x=canopy_class, fill=COMMON.NAME)) + geom_bar(width=0.75)
# or
ggplot(data=birds.int@data, aes(x=canopy_class, fill=COMMON.NAME)) + geom_bar(width=0.75, position = 'dodge')



######### SAT IMAGE ###########
# Now let's work with some satellite imagery.
# Let's list the TIF files within the ls.dir 
ls.files <- list.files(ls.dir, "*.TIF$", full.names = T)
ls.files
# We only want bands 6, 5, 4 (SWIR, NIR, red), which corresponds to files 8,7,6 in our list
ls.files <- ls.files[c(8,7,6)]
ls.files

# Even though they were delivered to us as individual bands, we can open them as a stack.
ls <- stack(ls.files) # You may get warnings here - ignore.
ls

# Let's look:
plot(ls)
levelplot(ls)
# Hmm, they both plot the bands individually. Can we look at them together?
plotRGB(ls, 1, 2, 3, scale=65535) 

# Let's calculate our own band: NDVI = (NIR - R)/(NIR + R)
# You can do math on rasters just like other objects in R.
system.time(ndvi <- (ls[[2]] - ls[[3]])/(ls[[2]] + ls[[3]]))
ndvi
plot(ndvi)

# maybe for this exercise, we don't need 30 m data - let's aggregate to 90m - often a better
# and quicker option than resampling.
ndvi.agg <- aggregate(ndvi, 3, mean)
ndvi.agg
plot(ndvi.agg)

# Discuss resample as a method for snapping one raster to another.
# Discuss processing large rasters 
