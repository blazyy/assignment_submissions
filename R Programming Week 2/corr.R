# Write a function that takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function should return a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0. A prototype of this function follows

corr <- function(directory, threshold = 0){
    
    files <- list.files(directory, full.names = TRUE) 
    corrs <- vector("numeric") # creating an empty vector 
    
    for(file in files){
        opened_file <- read.csv(file) 
        complete_cases <- complete.cases(opened_file) # boolean array of non-null values
        observed_cases_count <- sum(complete.cases(opened_file)) # get number of complete cases, only these should be used 
    
        #if(dim(opened_file[complete_c ases, ])[1] == 0) next
        
        if(observed_cases_count > threshold){
            opened_file <- opened_file[complete_cases, ] # getting all non-null rows using boolean vector 
            correlation <- cor(opened_file['nitrate'], opened_file['sulfate']) # calculating correlation between nitrate and sulfate levels
            corrs <- c(corrs, unname(correlation)) # unnaming because cor() function adds names to row and column which is unnecessary
        }
    }
    corrs
}