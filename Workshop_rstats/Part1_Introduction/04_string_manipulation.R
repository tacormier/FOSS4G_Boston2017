# Learning R: 04_string_manipulation.R
# author: Tina Cormier
# date: August, 2017

# Parsing strings in R.

# Use the print function
print("hello world")

# Set a variable to a character vector
x <- "Woods Hole Research Center"
x

# Get the length of a character vector
length(x)

# Why is this different than python's answer?
# Try:
nchar(x)

# Concatenate vectors using "print" and "paste"
x <- "hello world, I am "
y <- "from"
z <- " the United States."

print(paste(x, y, z, sep=""))

# Substrings in a character vector.
x <- "my name is Tina"
x
substr(x, 12, 15)

# Splitting strings according to a substring - result is a list.
x <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/july_precip.tif"
z <- strsplit(x, "/")
z
class(z)
# To pull out the 3rd element in the split
z[[1]][3]

# OR, can use the "unlist" command to place each element into a vector.
z <- unlist(strsplit(x, "/"))
z
z[3]
class(z)

# Creating new file names from existing files.
unlist(strsplit(x, "\\."))
newfile <- paste(unlist(strsplit(x, "\\."))[1], "_NEW.tif", sep="")
newfile

# String substitution
# to substitute the first occurrence of the word tcormier with "awesome."
sub("tcormier", "awesome", x)
gsub("tcormier", "awesome", x)

# To substitute all occurrences of a string.
x <- "mary had a little lamb, little lamb, little lamb"
# Using sub
sub("little", "HUGE", x)
# Now use gsub and note the difference
gsub("little", "HUGE", x)

# Searching for patterns (using regular expressions)
x <- c("image.tif", "biomass.tif", "help.csv", "precipitation.tif", "precipitation.xls")
# Find positions of all elements of x that end with .tif
grep(".tif", x)
# To find the "values" of all elements of x that end
# with .tif, rather than the positions:
grep(".tif", x, value=TRUE)

