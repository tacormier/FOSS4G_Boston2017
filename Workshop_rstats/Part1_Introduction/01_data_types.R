# Learning R: 01_data_types.R
# author: Tina Cormier
# date: August, 2017


######## REMARKS #########

# Everything in R is an object.
#
# The assignment operator '<-' is traditionally used to store
# objects as variables; however "=" will also work.
#
# R is case sensitive.
#
# In R, variable names may NOT start with a number.
#
# Take care not to use c, t, cat, F, T, or D as variable
# names.  Those are reserved by R.
#
# Vectors and Data Frames are the most common data types
# we will use in R to start.
#

######## BASIC DATA TYPES ########

# vectors, matrices, arrays, data frames, lists, factors, functions


# VECTORS - The basic data object in R.
# A vector is a one-dimensional array of arbitrary length.

# VECTOR TYPES - all elements in a vector must be of the same type.
# Numbers
num <- 4
num

# ***Note that R is case sensitive:
num <- 4
# is NOT the same as
Num <- 10

num
Num

# **Also, note that variable names may NOT start with a number:
# NOT OK
1num <- 5
# This works
num1 <- 5

# Can do mathematical operations to numbers
# multiply, divide, add, subtract, exponents
num * 5
num / 2
num + 8
num - 1
num^8


# Strings
string <- "hello world"
string


# Logical
logic <- "TRUE"
logic
#  logical test - boolean
logic == "FALSE"
logic == F
logic == T


# Vectors can be lists of like values (numbers, strings, logical, etc.)
# The ":" creates sequences that increment/decrement by 1.
x <- 1:10
x
x <- 1:-10
x

# Use "c" to "combine" or "concatenate" values.
x <- c(2, 4, 6, 8)
x
x <- c("R", "stats", "for", "the", "win")
x

# Use "seq" to create a sequence.
x <- seq(2, 8, by = 2)
x

# Can do mathematical operations on vectors. This is key for efficiency!
x*10


# MATRICES - A two-dimensional array with an arbitrary number
# of rows and columns.  All elements of the matrix must be 
# of the same type (numeric, character, etc.).

x <- matrix(c(1,2,3, 11,12,13), nrow = 3, ncol=2, dimnames = list(c("row1", "row2", "row3"), c("C.1", "C.2")))
x

# is an object a matrix (T/F)?
tx <- is.matrix(x)
tx

# Set object as a matrix.
x <- warpbreaks
x
class(x)
x <- as.matrix(warpbreaks[1:10,])
class(x)
x

# ARRAYS - A matrix of arbitrary dimensions.
x <- array(c(1,2,3, 11,12,13, 20,21,22), dim=c(3,3), dimnames = list(c("row1", "row2", "row3"), c("C.1", "C.2", "C.3")))
x

# DATA FRAMES - Most data will be stored in data frames,
# rectangular arrays that are usually formed by combining
# vectors (columns). Data frames, as opposed to matrices,
# can contain vectors of different types. Data frames are 
# LIKE your typical spreadsheet or database table.

# Constructing data frames
x <- seq(0, 10, length = 20)
x
y <- rep(c("a", "b", "c", "d"), 5) 
y

my.df <- data.frame(numbers=x, letters=y)
my.df

# A method for adding columns to a data frame.
# cbind means "column-binding."
newCol <- seq(1, 2, length=20)
my.df <- cbind(my.df, newCol)
my.df

# Another method for adding columns to a data frame. "$" indicates 
# column names in a data frame. This method is particularly useful
# for adding NEW columns.
# Try looking at the column named "numbers"
my.df$numbers
# Now add another new column
my.df$newest_column <- log(my.df$newCol)
my.df

# Can also delete column.
my.df$newest_column <- NULL
my.df

# LISTS - Lists are generic vectors.  Lists contain elements,
# each of which can contain any type of R object (i.e. the elements)
# of a list do not have to be of the same type.

# Here is an example of a list that contains 3 different classes:
# numbers, matrix, and even a function.

complicated.list <- list("a"=1:4, "b"=1:3, "c"=matrix(1:4, nrow=2), "d"=sd)

# What class is object complicated.list?
class(complicated.list)

# What classes are the individual elements in complicated.list?
# The "apply" group of functions operates nicely on lists (and other 
# objects) to apply a function to each element in the list. 
lapply(complicated.list, class)

# FACTORS - Represent an efficient way to store categorical values.
# Factors are frequently used in statistical modeling.  For instance, when 
# classifying land cover, the response "land cover type" is a categorical
# variable. Models handle factors differently than continuous variables, 
# such as biomass, precipitation, or elevation. Factors can be ordered
# or unordered

x <- c(3,2,1,3,1,2,1,3,1,2,3,3,2)
x
class(x)
fx <- factor(x)
fx
class(fx)
levels(fx)

# Ordered vs. unordered factors
# unordered
days <- c("sunday", "monday", "wednesday", "friday", "saturday","tuesday", "sunday","wednesday", "thursday", "friday", "saturday")
days
str(days)
un.days <- factor(days)

# Note that the days are not in order
table(un.days)

# But we know days happen in a certain order, and we can enforce that order.
or.days <- ordered(days, levels=c("sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"))
table(or.days)

# FUNCTIONS - R objects that allow the user to reduce complex
# procedures into a single command.  Useful for procedures that are
# run repeatedly with different inputs. R has a large number of "built-in"
# functions, like "mean," "plot," etc.  Users can create their own 
# functions as well.

# Built-in functions - examples
x <- c(5,48,12,45)
x

# Mean
mean(x)

# Sort
sort(x)

# Print
print(x)
paste("Working on process ", x, ". Almost done!", sep="")

# Plot
plot(x, x^2)





