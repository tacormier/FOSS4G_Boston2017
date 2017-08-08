library(lidR)
library(raster)
# las.file <- "/Users/tcormier/Documents/misc_projects/foss4g2017_presentation/Lunt_Lidar/Job347209_me2009_usgs_androscoggin/Job347209_me2009_usgs_androscoggin.las"
las.file <- "/Users/tcormier/Documents/misc_projects/foss4g2017_presentation/Lunt_Lidar/Job347208_ne2011_usgs_lftne/Job347208_ne2011_usgs_lftne.las"
shp.file <- "/Users/tcormier/Documents/misc_projects/foss4g2017_presentation/lidar_clip.shp"

shp <- shapefile(shp.file)

library(lidR)
# 1. Read the las file directly into R
las <- readLAS(las.file)

# 2. Plot the las file
plot(las)

# 2. Create a terrain grid at 1 m and use it 
# normalize points
dtm <- grid_terrain(las, res=1, "knnidw")
las.norm <- lasnormalize(las, dtm)


plot(las.norm)
plot3d(dtm)
# The old way, which was slower - and remember - required .txt version of all my files:
library(raster)
lasdata <- read.csv(lasfiles[p], header=F, col.names=c("x","y","z","i","a","n","r","c"))
ptground <- extract(dtm, lasdata[,1:2])
lasdata$z <- lasdata$z - ptground


# 3. Canopy model
canopy <- grid_canopy(las, method="knnidw")

# 4. Subract dtm from points to get a height model.


# Clip las with polygon
las.clip <- lasclip(las, geometry = "polygon", shp@polygons[[1]]@Polygons[[1]]@coords)
