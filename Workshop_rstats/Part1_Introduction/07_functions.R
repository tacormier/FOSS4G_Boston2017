# Learning R: 07_functions.R
# author: Tina Cormier
# date: August, 2017

# If you find yourself writing the same code over and over again,
# it might be time to make it a function!

# Defining a function
hello <- function() {
	print("Hello World")
	}
hello()

# A simple function
foo <- function(x) {
	print(paste0("the argument is ", x))
	}
foo("tina")
foo(67)

# A more complex function (with positional arguments)
add.stuff <- function(x,y,z) {
	print(paste("Arg x = ", x, sep=""))
	print(paste("Arg y = ", y, sep=""))
	print(paste("Arg z = ", z, sep=""))
	return(sum(x,y,z))
	}
	
add.stuff(4,5,6)
add.stuff(1,5)
	
# Naming arguments and setting default values
add.stuff <- function(x=2,y=1,z=NULL) {
	print(paste("Arg x = ", x, sep=""))
	print(paste("Arg y = ", y, sep=""))
	print(paste("Arg z = ", z, sep=""))
	return(sum(x,y,z))
	}

add.stuff()
add.stuff(y=4, z=9, x=23)

# A note of advice: Make your function do one thing, small and flexible.
# do testing outside the function.


################ A NOTE ABOUT VARIABLES & FUNCTIONS ################ 

x <- "I live in the global environment"
x

var <- function() {
	x <- "I live inside of my function"
	print(x)
	}

# So what is the value of "x" now?
var()
x

# We can assign the value of x in the function to a new 
# variable that is accessible outside of the function 
# (i.e., bring the value of x from inside the function into
# the global environment by assigning it to a varaible):
y <- var()
y

# x is still unchanged
x

# OR

# To export a variable within a function to the global
# environment, use "<<-". Use caution not to unintentionally 
# overwrite other global variables!
var2 <- function() {
	x <<- "Yay, now I'm global"
	}

# So what is the value of "x" now?
var2()
x
