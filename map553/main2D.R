# TODO: Add comment
# 
# Author: till

source("crossValidation.R")
source("dummyEstimatorGenerator.R")
source("leastSquaresEstimatorGenerator.R")
source("trigonometricDictionary.R")

numdatapoints <- 40
dimension <- 2
blocksize <- 20
a <- -10
b <- 10

xdatapoints <- (1:numdatapoints)/numdatapoints * (b - a) + a
minValue <- 2^.Machine$double.digits
minParameter <- 0

gauss <- function(x) {
    r <- sqrt((x[1, ])^2 + (x[2, ])^2)
    exp(-r^2/2)
}
sinc <- function(x) {
    r <- sqrt((x[1, ])^2 + (x[2, ])^2)
    sin(r)/r
}

ytemp <- rep(xdatapoints, each = length(xdatapoints))
xtemp <- rep(xdatapoints, length(xdatapoints))

x2datapoints <- rbind(xtemp, ytemp)

z <- sinc(x2datapoints)
z[is.na(z)] <- 1
y2datapoints <- z + rnorm(numdatapoints^2, sd = 0.02)

persp(xdatapoints, xdatapoints, matrix(y2datapoints, numdatapoints, numdatapoints))
scan(n = 1)

for (i in 2:35) {
    
    cat("i:", i, "\n")
    value <- crossValidation(x2datapoints, y2datapoints, leastSquaresEstimatorGenerator(trigonometricDictionary(dimension, 
        a, b), i), dimension, blocksize)
    
    if (value < minValue) {
        minValue <- value
        minParameter <- i
    }
    
    cat("value:", value, "\n")
    
    estimator <- leastSquaresEstimatorGenerator(trigonometricDictionary(dimension, 
        a, b), i)(x2datapoints, y2datapoints)
    estimatedpoints <- estimator(x2datapoints)
    persp(xdatapoints, xdatapoints, matrix(estimatedpoints, numdatapoints, numdatapoints))
    
    scan(n = 1)
}

estimator <- leastSquaresEstimatorGenerator(trigonometricDictionary(dimension, a, 
    b), minParameter)(x2datapoints, y2datapoints)
estimatedpoints <- estimator(x2datapoints)

 
