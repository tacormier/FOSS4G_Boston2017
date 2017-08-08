# Learning R: 03_indexing.R
# author: Tina Cormier
# date: August, 2017

# Indexing allows access to individual elements or subsets of objects.
# Indexing can be used to both extract part of an object and/or to replace
# parts of or add to an object.


################  VECTORS AND MATRICES ################  
# For vectors and matrices, the form x[i] or y[row,col] is generally used.
x <- c(3,7,9,2,NA,5)
x

# Extract element 4.
x[4]

# Extract elements 1-3.
x[1:3]

# Adding a "-" sign means "except."
# Extract all values except the 3rd
x[-3]

# Locate missing data
is.na(x)

# Remove missing data
x[!is.na(x)]
# or 
na.omit(x)

# Or replace missing data: 
# Here, you would read this line as "x, where x is NA, is now 10.
x[is.na(x)] <- 10
x

# Now a matrix
y <- matrix(c(2,7,9,2,NA,5), nrow=2)
y
dim(y)

# Find value at row 1, column 3 
y[1,3]

# Extract row 1, columns 1 and 2
y[1,1:2]

# Extract columns 1 and 3
y[,c(1,3)]

# Locate missing data
is.na(y)

################  DATA FRAMES ################  

# Indexing data frames can be done the same way as matrices.
# The format df$colname can also be used.

df <- as.data.frame(y)
df
names(df)
names(df) <- c("car", "toy", "sky")

# extract values from column called "toy"
df$toy
# or
df[,2]

# Do you want to know if an entire row is complete (no NA values)?
complete.cases(df)
# Now remove rows that are NOT complete - we often need to do this for modeling.
df.complete <- df[complete.cases(df),]

################  LISTS ################  

# Indexing lists
mylist <- list(x=x, y=y)
mylist
length(mylist)

# To access the first element in the list
mylist[[1]]

# To access the 1st column of the 2nd list element
mylist[[2]][,1]


################    WHICH FUNCTION ################  
# Returns indices of TRUE values in a logical vector. 
l <- LETTERS
l
which(l=="T")
l[20]

my.list <- c("helicopter", "plane", "car", "bus", "bicycle", "horse")
your.list <- c("fly", "run", "car", "drive", "pedal", "horse")

# Which positions in your.list match my.list
which(your.list %in% my.list)

# To get the actual values, instead of the positions
your.list[which(your.list %in% my.list)]
