# Write a function that reads a directory full of files and reports the number of completely observed cases in each data file. The function should return a data frame where the first column is the name of the file and the second column is the number of complete cases. A prototype of this function follows

complete <- function(directory, id = 1:332){
    files <- list.files(directory, full.names = TRUE)
    complete_df <- data.frame() # creating an empty dataframe
    
    for(i in id){
        
        opened_file = read.csv(files[i]) 
        complete_cases <- complete.cases(opened_file) # boolean vector of non-null rows
        opened_file <- opened_file[complete_cases, ] # file without NA values
        
        # if(dim(opened_file[complete_cases, ])[1] == 0){
        #    vect <- list(i, 0)
        #    complete_df <- rbind(complete_df, vect)
        #}
        #else{
        
        complete_cases <- table(complete.cases(opened_file))[['TRUE']] # getting number of completely observed cases, i.e. non-NA
        vect <- list(i, complete_cases) # each row of the final dataframe
        complete_df <- rbind(complete_df, vect)       
        
        #}
    }
    colnames(complete_df) <- c('id', 'nobs') # adding names because of question requirements 
    complete_df
}