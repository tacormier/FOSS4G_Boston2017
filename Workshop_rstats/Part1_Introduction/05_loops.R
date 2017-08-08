# Learning R: 05_loops.R
# author: Tina Cormier
# date: August, 2017

################ WHILE LOOP ################  
a=0
while (a < 10) {
    a=a+1
    print(a)
    }


################ FOR LOOP ################  
# for loop on a vector
a = c("harry", "joe", "peter")
for (name in a) {
   print(name)
   }

# Loop over each row in a data frame
x <- data.frame(seq(1,50, by=1.5), seq(1, 185, by=5.6))
names(x) <- c("A", "B")
x

for (i in c(1:nrow(x))) {
	# DO things.
	y <- x$A[i] + x$B[i]	
	print(paste("the value of A is ", x$A[i], ", the value of B is ", x$B[i], ", and A + B is ", y, sep=""))
	}

################ "APPLY" FUNCTIONS ################  
# apply and friends
# Can make code more efficient (to run and to read)
# by eliminating loops.

# lapply - loop over a list and perform a function on each element. 
# lapply always returns a list object, regardless of input class.
# sapply - same as lapply but simplifies the result, if possible
x <- c("bob", "harry", "abc", "i", "lisa")
x
# Using lapply to determine the number of characters in each element
lapply(x, nchar)

# Another example
x <- list(a = 1:10, b = rnorm(20))
x
lapply(x, mean)
# sapply returns a pretty vector instead of a list.
x.sapply <- sapply(x, mean)
x.sapply
# Now the same thing using a loop, for reference (5 lines instead of 1):
x.loop <- vector()
for (i in c(1:length(x))) {
  i.mean <- mean(x[[i]])
  x.loop[i] <- i.mean
}# end loop

# apply - apply a function over the margins of an array
# Useful if you want to perform the same function to all
# rows or columns in a matrix, for example.
x <- matrix(rnorm(200), 20, 10)
x

# Calculate the mean for each column (should be 10 columns)
apply(x, 2, mean)

# Calculate the mean for each row (should be 20 rows)
apply(x, 1, mean)

# tapply - apply a function over subsets of a vector
attach(iris)
str(iris)
head(iris)

# For each species type, find mean petal length - 
# this would involve looping over each unique species
# if we wrote a loop. Here = one liner!
tapply(Petal.Length, Species, mean)
