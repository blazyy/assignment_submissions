rankall <- function(outcome, num = "best") {
    ## Read outcome data
    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Check that outcome is valid 
    if(!outcome %in% c("heart attack", "pneumonia", "heart failure"))
        stop('invalid outcome')
    
    # Assign appropriate column names deopending on specified outcome
    if(outcome == "heart attack")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    
    else if(outcome == "heart failure")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    
    else
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    
    # Convert outcome column to numeric and remove rows with NAs in this column
    outcome_df[, col_name] <- as.numeric(outcome_df[, col_name])
    outcome_df <- outcome_df[!is.na(outcome_df[, col_name]), ]

    # Creating empty dataframe which we will fill and return later    
    return_df <- data.frame('hospital' = character(0), 'state' = character(0), stringsAsFactors = FALSE)
    
    # Looping through each state
    for(name in names(table(outcome_df$State))){
        
        # Getting rows pertaining to each state
        all_hospitals_in_state <- outcome_df[outcome_df['State'] == name, ]
        
        # Ordering rows by col_name first, then by alphabetical order
        ordered_hospitals_in_state <- all_hospitals_in_state[order(all_hospitals_in_state[col_name], all_hospitals_in_state['Hospital.Name']), ]
        
        # Depending on rank, index different parts of the dataframe
        if(num == "worst")
            hospital <- tail(ordered_hospitals_in_state[, 'Hospital.Name'], 1)
        else if(num == "best")
            hospital <- head(ordered_hospitals_in_state[, 'Hospital.Name'], 1)
        else if(num > nrow(all_hospitals_in_state))
            hospital <- NA
        else
            hospital <- ordered_hospitals_in_state[num, 'Hospital.Name']

        # Return dataframe appended with states and their ranked hospitals
        return_df[nrow(return_df) + 1, ] <- c(hospital, name)
    }
    return_df
}
