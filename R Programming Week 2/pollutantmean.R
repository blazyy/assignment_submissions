
# Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA. A prototype of the function is as follows


pollutantmean <- function(directory, pollutant, id = 1:332){
    files <- list.files(directory, full.names = TRUE)
    df <- data.frame()
    
    for(file in files[id]){
        df <- rbind(df, read.csv(file))
    }
    mean(df[, pollutant], na.rm = TRUE)
}
