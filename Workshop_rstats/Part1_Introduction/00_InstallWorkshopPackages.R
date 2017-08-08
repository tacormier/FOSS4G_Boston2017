# Learning R: installPackages.R
# author: Tina Cormier
# date: August, 2017

# Description: Installs the packages we need during the FOSS4G workshop.
p1 <- proc.time() # timing your code :)

#################################
install.packages("raster") # raster AND vector analysis
install.packages("rgdal") # bindings to GDAL (must have gdal installed).
install.packages("maptools") # provides various mapping functions, BUT I don't recommend using it to read/write files bc it drops projection information. 
install.packages("ggplot2") # data visualization package that breaks graphics into component parts (e.g., plot, layers, scales).
install.packages("data.table") # enhanced version of data.frames. FAST.
install.package("lubridate") # package that facilitates working with dates and times.
install.packages("RColorBrewer") # premade color palettes for plots
install.packages("colorRamps") # package to build custom gradient color ramps
install.packages("sf") # simple features
install.packages("tmap") # layer-based approach to building thematic maps
install.packages("rasterVis") # visualization of raster data
install.packages("gdalUtils") # wrappers for GDAL utilities
install.packages("ggmap") # visualize spatial data atop static maps from online sources
install.packages("rgeos") # interfact to GEOS (Geometry Engine - Open Source)
install.packages("dplyr") # A fast tool for working with data frame like objects
install.packages("sp")  # working with spatial objects (this package will be installed with raster, but wanted to explicitly recognize it as important)
install.packages("leaflet")  # interactive web mapping using Leaflet - we won't use this today, but web mappers may want to play with it!
#################################
p2 <- proc.time()
p2-p1

# Note that several of these packages are in the tidyverse package, which would be great to explore.
# You can install that if you wish - it installs multiple packages that are part of the "tidyverse,"
# a collection of packages with similar philosophies that are designed to work together.
# (e.g., ggplot, dplyr, lubridate, stringr, etc.) 

# Needed?
# install.packages("reshape")
