# Below function creates a special matrix object which basically has some extra functionality that can 
# cache its inverse so that it doesn't have to be calculated again. Useful for very large matrices.

# The <<- is used to set the value of x and i in another environment, i.e the environment it was defined in,
# i.e. inside makeCacheMatrix(). If <- was used, it would've set the value of two different variables x and i 
# residing in the set() and setinverse() environments respectively, which would've recalculated the inverse each 
# time because i would be NULL and x would be the initial 'normal' matrix that we've used to find the inverse.

makeCacheMatrix <- function(x = matrix()) {
    i <- NULL
    # Strange because the below function is never used explicitly. 
    set <- function(y){
        x <<- y 
        i <<- NULL
    }
    # Returns matrix that we gave as input. Needed because we have to pass the value of our input matrix to
    # another function
    get <- function() x
    
    setinverse <- function(inverse) 
        i <<- inverse
    
    getinverse <- function() 
        i
    # Returns a list of named functions that we can invoke when needed.
    list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}

# cacheSolve() checks if the inverse has already been computed before. If so, it retrieves cached data by getting
# the value from getinverse(), which is our 'special' matrix's function which returns the value of i.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        i <- x$getinverse()
        # Check to see if inverse has been pre-computed
        if(!is.null(i)){
            message("Getting cached data...")
            return(i)
        }
        # If not, compute inverse and store in our special matrix object using setinverse()
        data <- x$get()
        i <- solve(data, ...) # solve() finds inverse of a matrix
        x$setinverse(i)
        i
}

# To test, run 
# cached_matrix <- makeCacheMatrix(my_matrix)
# cacheSolve(cached_matrix)
# Running cacheSolve the first time for a large matrix will take some time.
# If you run it again, it will be instant. 
