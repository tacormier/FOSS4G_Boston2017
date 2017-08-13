# Learning R: vectorProcessing.R
# author: Tina Cormier
# date: August, 2017

# Description: Learn how to do basic geoprocessing and visualization with vector files.

######################################
library(raster) # raster AND vector analysis
library(data.table) # enhanced version of data.frames. FAST.
library(rgdal) # bindings to GDAL (must have gdal installed).
library(ggplot2) # a plotting system in R (much NICER than base plotting)
library(RColorBrewer) # Color palettes
library(colorRamps) # package to build gradient color ramps
library(sf) # simple features
library(rlist) # a set of functions for working with lists
library(dplyr) # A fast set of tools for working with data frame like objects
# library(plotly) # a graphing package for interactive plots
library(tmap) # layer-based approach to building thematic maps
library(gganimate) # create animated ggplot2 plots
######################################
wd <- "/home/user/R_workshop/data/"
setwd(wd)

# 1. Re-open cleaned birds txt file
birds <- fread("eBird/ebd_NE_4spp_workshopData_dataCleanup.txt", sep=" ")

# 2. Convert to spatial points df
# Although we've plotted the points, we haven't yet defined our birds data table as
# a spatial object. First, which columns are the coordinates?
birds.xy <- birds[,c("LONGITUDE", "LATITUDE")]
birds.sp <- SpatialPointsDataFrame(coords=birds.xy, data=birds, proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
birds.sp
# We could write this out to a shapefile if we want to now:
shapefile(birds.sp, "eBird/ebd_NE_4spp_workshopData_sp.shp", overwrite=T)
# Thanks ESRI - cut our field names. How about a geojson file instead?
writeOGR(birds.sp, "eBird/test_geojson", layer="birds", driver="GeoJSON")

# 3. Visualize
plot(birds.sp)
# That's kind of ugly, but we can see our geography issues have been resolved! How about this?
library(tmap) 
# qtm = quick thematic map = parallel structure to ggplots 'qplot'
qtm(shp = birds.sp, symbols.col="COMMON.NAME")
# Nicer - but points are huge - let's adjust
qtm(shp = birds.sp, symbols.col="COMMON.NAME", symbols.size=0.15)
# Great! Now let's fix the legend title, and add a north arrow and scale bar.
m <- qtm(shp = birds.sp, symbols.col="COMMON.NAME", symbols.size=0.15, 
    title="Species Observations\n2014 - 2017", symbols.title.col="Common Name") +
  tm_compass() + tm_scale_bar()
m

# a map by date?
p <- ggplot(birds.sp@data, aes(x=LONGITUDE, y=LATITUDE)) + geom_point()
p
# add some color and frame by year
p <- ggplot(birds.sp@data, aes(x=LONGITUDE, y=LATITUDE, color=COMMON.NAME, frame=year)) + geom_point()
p

gganimate(p) # cool!
gganimate(p, "birds_byYear.gif")

# 4. Bring in county layer
county <- shapefile("boundaries/USA_adm2_conus_albers.shp")
county
# plot(county)
str(county) # YIKES!

# NOTE sf package: New package that simplifies life with spatial objects in R
county.sf <- read_sf("boundaries/USA_adm2_conus_albers.shp") # note the speed!
# Be careful plotting this one though! If you just execute plot(county.sf), you'll get a separate plot
# for each column in the table...SLOW. Specify which column
# plot(county.sf[,"NAME_2"])

# For reference - to reach the attribute table of the county variable (s4 object), we need to call
# the "data" slot, and we do that with an @ symbol. Like '$' references column names, '@' references
# slots in an object. (Simple features eliminates this and let's you treat the spatial object as a data frame).
head(county)
# example of how to extract specific rows from the attribute table
county@data[county$NAME_2 == 'Rockingham',] # results in rows from the table (non-spatial)
county[county$NAME_2 == 'Rockingham',] # results in polygon selection (spatial)

# 5. Project points to match county
# What is the projection of each of our data sets?
# There is a handy function in the raster package to help us out
projection(birds.sp)
projection(county) 
# or on the simple features layer - just multiple ways of doing the same thing!
st_crs(county.sf) 

# Let's continue on with county polygons, but know that simple features exist and you should check them out! 
# WHY are we using something a bit older, slower, and clunkier? Well, eventually we want to integrate some raster
# stuff, and the raster package can't deal with sfs just yet (it's super new, y'all!). If you ONLY work with
# vectors, I suggest trying out simple features, which seems poised to replace the sp package in the future.

# Ok, back to our regularly schedule reprojection:
birds.proj <- spTransform(birds.sp, CRS(projection(county)))
plot(birds.sp)
plot(birds.proj)
# Yay, projected

# 6. Clip points by counties to remove points in the ocean. Also show how intersect does same thing.
# Looks like we have some points in the ocean! We'll use the raster package's intersect function.

# The raster::intersect function uses a command you're probably familiar with AND it appended the county layer's
# attributes onto the table from birds.proj
# birds.int <- raster::intersect(birds.proj, county)  # you can try running this line and see what happens.

# On the VM, we probably get a memory error here. This is a good time to
# illustrate looping to get around a memory error.
for (i in 1:length(county$ID_2)) {
  print(i)
}

# Cool, now let's really do stuff in that loop.
# First, set up output
birds.int <- list()
i=1
for (i in 1:length(county$ID_2)) {
  print(paste(county$NAME_2[i], county$NAME_1[i], sep=", "))
  bi <- raster::intersect(birds.proj, county[i,])
  if (nrow(bi@data) == 0) {
    print("no intersecting features")
    next()
  } else {
    birds.int <- list.append(birds.int, bi) 
  }
}
#
# Ok, let's kill that - there's no sense in looping over states/counties
# where we now we don't have data = inefficient!
# We have state info in the bird data set, so let's select from
# the counties every state that matches in the bird data:
county.sel <- county[county$NAME_1 %in% birds.proj$STATE_PROVINCE,] # WOAH, WTH is that? It's awesomeness.
# Did that work?
# plot(county.sel)
unique(county.sel$NAME_1)

# Try our loop again, but with county.sel in place of county:
birds.intlist <- list()
for (i in 1:length(county.sel$ID_2)) {
  print(paste(county.sel$NAME_2[i], county.sel$NAME_1[i], sep=", "))
  bi <- raster::intersect(birds.proj, county.sel[i,])
  if (nrow(bi@data) == 0) {
    print("no intersecting features")
    next()
  } else {
    birds.intlist <- list.append(birds.intlist, bi) 
  }
}

birds.intlist
# Well, we don't want a list of features, we want one spatial object containing
# all of the features.
birds.int <- do.call(bind, birds.intlist)

# What has changed about our spatial points?
head(birds.int)

# A side note: If we ONLY wanted to clip/subset the points, R can use the same indexing syntax - square brackets - 
# to select a subset as it does for other objects, AND it's faster!
birds.sub <- birds.proj[county,]

# Back to birds.int. Now we have two "state" fields - one originating from the eBird data set and 
# the other from our admin boundaries. Let's do a quick QA check to see if the state listed in 
# eBird == admin boundary state.
birds.check <- birds.int[birds.int$STATE_PROVINCE != birds.int$NAME_1,]
head(birds.check) # SHOOT! More data clean up.
# Which one is right? Don't know, so let's trash any that don't match.
birds.int <- birds.int[birds.int$STATE_PROVINCE == birds.int$NAME_1,]
# Check again to see if we have any non-matching 


# 8. Summaries spp by county and state
# Let's check in with our "apply" family of functions to get some quick info
# tapply = table apply to get counts per county and per state
birds.pc <- tapply(birds.int$OBSERVATION.COUNT, birds.int$ID_2, sum)
birds.pc # Why did we do this by ID and not by county name?
birds.ps <- tapply(birds.int$OBSERVATION.COUNT, birds.int$ID_1, sum)
birds.ps

# or by state name:
birds.ps <- tapply(birds.int$OBSERVATION.COUNT, birds.int$NAME_1, sum) # Why doesn't summarizing by name work with counties?
birds.ps

# 9. Let's make some plots!
# Plots of spp observered over time
# Let's sum the number of observations per date per species, just to get an idea
birds.agg <- aggregate(OBSERVATION.COUNT~OBSERVATION.DATE+COMMON.NAME, birds.int@data, FUN=sum)
# Now we need "OBSERVATION.DATE" as a date - remember how to do that?
library(lubridate)
birds.agg$OBSERVATION.DATE <- as_date(birds.agg$OBSERVATION.DATE)
summary(birds.agg)

# Now some plotting
ggplot(data=birds.agg, aes(x=OBSERVATION.DATE, y=OBSERVATION.COUNT, color=COMMON.NAME)) + geom_line()
# Interesting, but large spikes of big birding days (great backyard bird count, etc.?) are making it hard to see trends.
# Let's look at just trend lines
# NOTE: Aesthetics supplied to ggplot() are used as defaults for every layer.
# you can override them, or supply different aesthetics for each layer.
ggplot(data=birds.agg, aes(x=OBSERVATION.DATE, y=OBSERVATION.COUNT, color=COMMON.NAME)) + geom_smooth()
# ok, can we remove the se bars?
ggplot(data=birds.agg, aes(x=OBSERVATION.DATE, y=OBSERVATION.COUNT, color=COMMON.NAME)) + geom_smooth(se=F)

# Maybe nicer as a barplot? - but only by year
birds.agg$year <- year(birds.agg$OBSERVATION.DATE)
ggplot(data=birds.agg, aes(x=year, y=OBSERVATION.COUNT, fill=COMMON.NAME)) + geom_bar(stat='identity')
# Why stat=identity? From geom_barplot() docs: By default, geom_bar uses stat="count" which makes the 
# height of the bar proportion to the number of cases in each group. If you want the heights of the 
# bars to represent values in the data (we do, because the values ARE the counts), use stat="identity" 
# and map a variable to the y aesthetic.

# Now we'd like side by side bars:
ggplot(data=birds.agg, aes(x=year, y=OBSERVATION.COUNT, fill=COMMON.NAME)) + 
  geom_bar(stat='identity', position='dodge')
# We can save plots to objects for later printing to a graphics device (pdf, png, etc.)
# It also helps you set up your base graph and you can try adding new/different geoms.
# The typical syntax=
p <- ggplot(data=birds.agg, aes(x=year, y=OBSERVATION.COUNT, fill=COMMON.NAME))
p <- p + geom_bar(stat='identity', position='dodge')
p
# Can we make it interactive? - commented out because this will only work with the most
# recent version of ggplot2. We have installed a slightly older version to work with ggmap.
# Sigh, it's complicated. But I'm leaving this here for you to try at another point!
# ggplotly(p) # There are a lot of ways to customize, but it's this simple to get started!

# Let's aggregate again, but this time by county ID
birds.cy <- aggregate(OBSERVATION.COUNT~ID_2, birds.int@data, FUN=sum)
# Let's add the county names on there, which requires some matching between tables
# We could join the tables, but we don't want all of the fields from birds.int - just one!
birds.cy$county <- birds.int$NAME_2[match(birds.cy$ID_2, birds.int$ID_2)] # match gives the first match only, but that's all we need here.
birds.cy

# New county layer with just these 6 New England states
county.ne <- county[county$NAME_1 %in% birds.int$NAME_1,] 
# plot(county.ne)
# Let's write this to a shapefile for later :)
shapefile(county.ne, "boundaries/county_ne.shp", overwrite = T)

# 10. Map where county color is # bird observations?
# First, need to join the count information from birds.cy to our new county.ne spatial polygons data frame.
# There are multiple ways we could do it - I'll show you two:
# a. the base R way
county.ne$count <- birds.cy$OBSERVATION.COUNT[match(county.ne$ID_2, birds.cy$ID_2)]

# Now the tidyverse way (a way of thinking about programming that is cleaner and easier - ggplot is in that group)
# Let's use a new variable to be safe
county.ne2 <- county.ne@data %>% left_join(birds.cy) # cool, right? - it appends the other fields as well.

# Let's take a quick glance at a summary of the table before we map:
summary(county.ne)
# Let's record where count is NA = 0
county.ne$count[is.na(county.ne$count)] <- 0
summary(county.ne)

# Ok, let's map! # choropleth
qtm(county.ne, fill = "count")
# try a different color palette
qtm(county.ne, fill = "count", style='col_blind')
# now something else
qtm(county.ne, fill = "count", fill.palette="-YlGnBu")
# not thrilled with the breaks on this map - let's set our own!
# Let's see how deciles look
breaks <- quantile(county.ne$count, probs=seq(0,1,by=0.1))
qtm(county.ne, fill = "count", fill.palette="Purples", fill.style="fixed",fill.breaks=breaks)

# Another common GIS function = dissolve. Let's dissolve counties to states
states <- aggregate(county.ne, by="NAME_1")
qtm(states) # complex boundaries, so will take a moment to plot.

      
# 11. Birding hotspots?
# Let's try ggmap
library(ggmap) # Spatial visualization with ggplot2
m <- qmap(location="new england", zoom=6) # set location and background
m + geom_point(data=birds.int@data, aes(x=LONGITUDE, y=LATITUDE)) # Well, that's something.
# Let's try to get the density (2-D kernel density estimation!
m + stat_density2d(data=birds.int@data, aes(x = LONGITUDE, y = LATITUDE))

# How about filled contours to show birding hot spots? We'll use default colors for now
# Hints as we go along: try changing the # of bins, the colors, and the alpha levels. Just play!
m + stat_density2d(data=birds.int@data, aes(x = LONGITUDE, y = LATITUDE, fill = ..level..,alpha=..level..), bins = 30, geom = "polygon")

# Hmmm, Massachusetts is popular - let's zoom in and make a few changes
mm <- qmap(location='boston', zoom=10, color="bw") # Can make background map black and white.
# OR
# Choose another source
mm <- qmap(location='boston', zoom=10, source="google", maptype="satellite")
# OR
# Our original - the background you choose will affect which colors you like as we go along.
mm <- qmap(location='boston', zoom=10)
mm

# first, with default colors:
mm.density <- mm + stat_density2d(data=birds.int@data[birds.int@data$NAME_1=='Massachusetts',], aes(x = LONGITUDE, y = LATITUDE, fill = ..level..,alpha=..level..), bins = 15, geom = "polygon") +
  ggtitle("Birding Hotspots") +
  guides(alpha=FALSE) # Turn off alpha legend item

mm.density

# Now start to play by using scale_fill_gradient argument (you may find you like the default best!)
# Pick some new colors - here are a bunch of ideas - try your own too!
display.brewer.all()
# Also check out https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf for more ideas
# density.colors <- c("gray20", "gray50", brewer.pal(9, "Blues")[6:9]) # custom mix
# density.colors <- brewer.pal(9, "PuBuGn")[5:9] # RColorBrewer package
# density.colors <- rev(brewer.pal(11, "Spectral")[1:4]) # RColorBrewer package
# density.colors <- rev(heat.colors(4, alpha=1)) # From colorRamp package

# These next few options are actually creating a color ramp function, which accepts a number (# of colors in ramp)
# density.colors <- blue2green2red(50) # From colorRamp package
# density.fun <- colorRampPalette(c("gray30", "blue4", "green4", "red3"))
# density.fun <- colorRampPalette(c("gray40", "black")) # A little grayscale to make the points pop?
density.fun <- colorRampPalette(c("darkslategray","darkred", "red"))
density.colors <- density.fun(4)

mm.density <- mm + stat_density2d(data=birds.int@data[birds.int@data$NAME_1=='Massachusetts',], aes(x = LONGITUDE, y = LATITUDE, fill = ..level..,alpha=..level..), bins = 15, geom = "polygon") +
  scale_fill_gradientn(colors=density.colors) +
  ggtitle("Birding Hotspots") +
  guides(alpha=FALSE) #+
  # scale_alpha_continuous(range=c(0.06,0.5)) # By default, the alpha scales from 0.1 to 1. We can adjust to our liking, especially when point density is high.

mm.density

# add points on top, colored by species - kind of a mess, but you can do it.
mm.density + geom_point(data = birds.int@data, aes(x=LONGITUDE, y=LATITUDE, color=COMMON.NAME), size=0.6, alpha=0.5) +
  scale_colour_manual(values=brewer.pal(4, "Set1")) + # You can try different point colors too! Comment out for defaults.
  guides(color=guide_legend(override.aes=list(fill=NA, linetype = 0, alpha=1, size=1))) # no boxes around legend items

# Now we have a projected, intersected point file and a clipped county file. Let's write them out for later (we already
# wrote the county to a shapefile, but for the sake of learning). Won't use shapefiles because they will truncate our field 
# names in the ebird data. Not geoJSON because they can't handle projections. How about an 
# RDATA file for later? Excellent!
save(birds.int, county.ne, file="eBird/birds_counties.RDATA")
