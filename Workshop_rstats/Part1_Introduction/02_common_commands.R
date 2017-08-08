# Learning R: 02_common_commands.R
# author: Tina Cormier
# date: August, 2017

# Examples of common, useful commands in R.

# Commands are usually issued in the form of FUNCTIONS in R.
# Functions are called by entering the name of the function, 
# followed by parentheses.  Some functions have arguments, 
# which are specified within the parentheses.

# Getting help
# A web-based set of help pages
help.start()
# Show details of a function
# We will go over what a function is and how to
# know what the arguments are.
help(mean)
# A short cut to do the same thing
?mean
# Gives a list of functions involving the word "mean"
help.search("mean")
# A short cut to do the same thing. The ?? utility can handle misspelled words.
??mean
# Run the examples from the help page
example(mean)


# The quit function
# q()

# Setting your working directory
# The default location where R will look to read and 
# write files.

# To see current working directory
getwd()

# To change or set your working directory
setwd("/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/")
getwd()

# To list user-defined objects and functions 
ls()
# or
objects()

# To remove a variable from the workspace
x <- "hello world"
x
rm(x)
x
# or to remove ALL variables from the workspace
rm(list=ls())

# Exploring data
colnames <- c("speed", "distance")
x <- data.frame(seq(1,50, by=1.5), seq(1, 185, by=5.6))
# Change the names of the columns
names(x) <- colnames

# Determining the class/type of an object
class(x)
class(x$speed)

# Finding the structure of an object
str(x)

# Names
names(x)

# Quick view of the data (without printing thousands of lines)
head(x)
head(x, 3)
tail(x)

# Finding the dimensions of an object (rows,columns).
# Works for multi-dimensional objects. For vectors, 
# use length().
dim(x)
length(x$speed)

ncol(x)
nrow(x)

# Sorting
y <- sample(0:50, 20, replace=FALSE)
sort(y)
rev(y)

# Matching
# Find position of maximum/minimum value in a vector
which.max(y)
which.min(y)

# Find positions of values in y that are also in x$speed (logical vector)
y %in% x$speed

# Some math
mean(x$speed)
max(x$speed)
min(x$distance)
range(x$distance)

x/10

summary(x)

# Subsetting
subset(x, x$speed < 31.0)

# Tables
apples <- c("McIntosh", "Granny Smith", "Red Delicious", "McIntosh", "McIntosh", "Granny Smith")
table(apples)

# Putting vectors together to create data frames/matrices.
y <- sample(0:50, 20, replace=FALSE)
z <- sample(89:500, 20, replace=FALSE)

# Create a matrix treating y and z as rows.
rbind(y,z)

# Create a matrix treating y and z as columns.
cbind(y,z)



