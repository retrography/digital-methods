# A quick and dirty introduction to R 
# see R intro guide here: https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf

# R is object oriented; everything centers around objects, the values they store and the operations they allow

# a is an object:
a
# but a has not been defined
# define a
a <- 1
# now a holds the single numeric value: 1
a

# object can be defined by interacting with other objects
# make b  a copy of a
b <- a
# make b the sum of a plus 2 (a needs to be defined for this to work!)
b <- a + 2
# Note that R knows basic mathematical operations and can deal with standalone numeric values 
b

# objects are operated on by functions
# functions follow the structure; "function name(argument 1, ..., argument n)" and produce an output
# compute the mean of the values stored in a and b: 
mean(c(a,b))

# and the result of functions can in turn be stored in another object
c <- mean(c(a,b))

# if at any time something is not clear type: help(function name) or the equivalent ?function name 
help(mean)
?mean


