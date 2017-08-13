# Learning R: dataCleanup.R
# author: Tina Cormier
# date: August, 2017

# Sometimes we just get crappy data handed to us. Ok, a lot of the time.
# R is an excellent tool for finding and fixing issues.

# Someone [your boss, a client, the governor - anyone] gives you a text file
# representing some point observations. He wants you to do a GIS analysis with
# the points, but when you open it, you realize you've got some issues to solve
# first.

######################################
library(data.table) # enhanced version of data.frames. FAST.
library(ggplot2) # data visualization package that breaks graphics into component parts (e.g., plot, layers, scales).
wd <- "/home/user/R_workshop/data/"
setwd(wd)

# You could also use read.csv from base R here, but fread is way faster if you have large tables.
# OH, and by default, it sets "stringsAsFactors" to FALSE, which is amazing. 
system.time(birds <- fread("eBird/ebd_NE_4spp_workshopData.txt", sep=" "))
system.time(birds2 <- read.table("eBird/ebd_NE_4spp_workshopData.txt", stringsAsFactors = F, header = T))

# A quick preview of the table:
head(birds)

# Dimensions?
dim(birds)

# What about the structure (i.e., what are the characteristics of the fields?)
str(birds)

# Ok, we see geo coordinates, let's plot them quick and dirty just to get an idea of
# the data:
plot(birds$LONGITUDE, birds$LATITUDE, pch=20, col='orange')

# Eeeek. Something bad happened. 
# LAT and LON are swapped AND it looks like we have an errant state.
# We need to swap the LONGITUDE and LATITUDE fields, and there are many
# ways to do that.
# One way is to create two new columns and assign the correct values to them.
birds$x <- birds$LATITUDE
birds$y <- birds$LONGITUDE

# Write your own plot statement here using the names of your new columns,
# and make the points 'blue':


# Another way to swap the values in your columns - this way makes the change in place rather
# than creating new columns.
birds[ , c("LATITUDE", "LONGITUDE")] <- birds[ , c("LONGITUDE","LATITUDE")]

# Ok, now we have a state included that is outside of New England. As GIS analysts,
# our minds go right to "clipping it out," but we can do something even easier! 
# Let's see what states we have in the data set:
unique(birds$STATE_PROVINCE)

# Ohio is the culprit 
# Let's remove OHIO from our point data, which we can do quickly with a tabular
# function rather than a spatial one!
# First, how many records do we have?
dim(birds)
birds <- birds[birds$STATE_PROVINCE != 'Ohio',]
dim(birds)
unique(birds$STATE_PROVINCE)
plot(birds$LONGITUDE, birds$LATITUDE, pch=20, col='orange')

# Now let's say we want to see a plot of date vs. count of birds 
# observed. First, let's see how our date field is formatted.
str(birds$OBSERVATION.DATE)

# Since R understands dates and can do math based on them (and can do other things,
# like convert from a regular date to julian day), we'll convert that field to a date field.
# We'll use the lubridate package to help us.
library(lubridate) # package that facilitates working with dates and times.

# Let's let lubridate guess the date format for us, since that can be a pain (especially
# if they aren't consistent. HINT: they're not consistent).
# Let's create a new variable equal to "birds," so we don't have to start over
# if we (when) mess it up!
birds2 <- birds
birds2$OBSERVATION.DATE <- as_date(birds2$OBSERVATION.DATE)
# Ok, it ran without error, but let's check it out anyway. 
str(birds2$OBSERVATION.DATE)

# Excellent, the field is now formatted as a date.
# One other check: should all be between 2014 and 2017 - have to have some knowledge of your data set.
unique(year(birds2$OBSERVATION.DATE))
# SHOOT, we have issues! One way to ID where they are:
birds2$OBSERVATION.DATE[grep("^20",year(birds2$OBSERVATION.DATE), invert = T)]
# Almost the same command, but find positions of messed up dates. Note grep vs grepl (grep-logical = T/F 
# for matches rather than the value itself).
pos <- which(grepl("^20",year(birds2$OBSERVATION.DATE)) == F)

# Let's fix those that we identified as different. 
# First, what were they in our original table? How are the ones we flagged
# different in format than the rest of the table?
birds$OBSERVATION.DATE[pos]
# vs. 
head(birds$OBSERVATION.DATE)
# Note the difference in format.

# We can use lubridate to fix the format, but we'll need to treat them separately.
# Start over with dates from data set before you changed the dates.
# We'll tell R it's mdy format just at those positions, and it will format them
# to the more standard year, month, day like the rest of the table.
birds2 <- birds
birds2$OBSERVATION.DATE[pos] <- as.character(mdy(birds2$OBSERVATION.DATE[pos]))
# Quick look to see what happened:
birds2$OBSERVATION.DATE[pos] # BOOM!

# Now run the original command again and convert all to date format (instead of character):
birds2$OBSERVATION.DATE <- as_date(birds2$OBSERVATION.DATE)
# And check again to make sure we did what we thought we did!
unique(year(birds2$OBSERVATION.DATE)) # YAY!

# Since we fixed that, let's go back to using just the 'birds' variable.
birds <- birds2

# Why do we care if we have something in date format (vs. character)? Sometimes we don't. BUT,
# if we want to plot a time series or group things by date, then this makes it way easier. 
# Since R sees it as a special date field, we can also do things like this, which you can't do with text:
max(birds$OBSERVATION.DATE)
median(birds$OBSERVATION.DATE)
min(birds$OBSERVATION.DATE)

# Let's label each row with its year
birds$year <- year(birds$OBSERVATION.DATE) # Look - no parsing!

# Observations by species across years (we'll learn more about ggplot later!),
# but look - no date formatting in the graph! 
# First make sure our count field is numeric (hint, it isn't, see?)
str(birds)
birds$OBSERVATION.COUNT <- as.numeric(birds$OBSERVATION.COUNT)

ggplot(data=birds, aes(x=OBSERVATION.DATE, y=OBSERVATION.COUNT, color=COMMON.NAME)) + geom_point(alpha=0.25)

# Moving on from dates, which could be a course in itself,
# let's check for duplicate rows!
# Are there any?
birds[duplicated(birds),]
# Seems to be! How many?
dim(birds[duplicated(birds),])
# There are a couple of ways to rid your data set of duplicates, but this one is easy
# to remember: duplicated function.
# First check to see how many records are in your dataset:
dim(birds)
birds <- birds[!duplicated(birds),]
# Now how many are there? 

# Lastly, for our purposes, let's say we only want data with complete rows (no NAs).
# Are there any incomplete rows?
birds[!complete.cases(birds),]
# Of course there are! How many?
nrow(birds[!complete.cases(birds),])
# Remove! - but do a row check first
nrow(birds)
birds <- birds[complete.cases(birds),]
# check rows again to make sure we removed the duplicate rows.

# Excellent! Let's write out this new clean table (or look in your data directory for my version.)
write.table(birds, "eBird/ebd_NE_4spp_workshopData_dataCleanup.txt", row.names=F)
# or
fwrite(birds, "eBird/ebd_NE_4spp_workshopData_dataCleanup.txt", sep=" ") 
