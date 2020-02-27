# Write a function that reads a directory full of files and reports the number of completely observed cases in each data file. The function should return a data frame where the first column is the name of the file and the second column is the number of complete cases. A prototype of this function follows

complete <- function(directory, id = 1:332){
    
    files <- list.files(directory, full.names = TRUE)
    df <- data.frame() 
    
    for(i in id){
        opened_file <- read.csv(files[i])
        opened_file <- opened_file[complete.cases(opened_file), ]
        num_complete_cases <- sum(complete.cases(opened_file)) 
        vect <- list(i, num_complete_cases)
        df <- rbind(df, vect)       
    }
    
    colnames(df) <- c('id', 'nobs')
    df
}

