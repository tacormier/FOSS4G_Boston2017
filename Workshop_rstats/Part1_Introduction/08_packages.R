# Learning R: 08_packages.R
# author: Tina Cormier
# date: August, 2017

# The base version of R is powerful in itself; however
# the capabilities of R can be extended through user-created 
# packages. Packages are collections of R functions, data, 
# and compiled code. Currently, there are over 10,000 packages 
# available at the CRAN (Comprehensive R Archive Network), 
# Bioconductor, and other repositories.

# R already has a standard set of packages available when you
# install.  Other packages are available for download. Once 
# installed, they have to be loaded into your R session to be
# used.

# Get your library location (where does R look for packages?)
.libPaths()
# See all installed packages
library()
# See all currently loaded packages
search()

# You can expand/enhance the types of analyses you do by adding
# other packages.

# Will provide a list of packages to choose from
# First choose your closest CRAN mirror
chooseCRANmirror()
install.packages("foreign")

# OR

# Essential dependencies will also be downloaded and installed.
install.packages("randomForest")
# Installing this 
install.packages("zyp", lib="/Users/tcormier/Library/R/2.11/library")

# If you want to install ALL dependencies:
install.packages("randomForest", dependencies=TRUE)

# OR

# Go to the "Tools" menu, choose "Packages."

# To USE the new package, must load it into your R session or script.
# Can use either "library" or "require."  "require" is designed for use 
# inside of other functions; it will return "FALSE" and give a warning
# (rather than an error, as the "library" function will do by default)
# if the package does not exist.
library(randomForest)

# To remove a package
remove.packages("zyp", lib="/Users/tcormier/Library/R/2.11/library")

