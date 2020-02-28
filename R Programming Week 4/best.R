best <- function(state, outcome) {

    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    # if(dim(table(outcome_df$State == 'AZ')) == 1) 
    
    if(!state %in% outcome_df$State)
        stop('invalid state')
    
    if(!outcome %in% c("heart attack", "pneumonia", "heart failure"))
        stop('invalid outcome')
    
    if(outcome == "heart attack")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
        
    else if(outcome == "heart failure")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"

    else
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    
    
    # Getting only the requires states
    states <- outcome_df[outcome_df['State'] == state, ]
    
    # Need to convert to numeric as the column is of type character. When sorting, "11.7" will be greater than "9.7" which we don't want.
    # Will show warnings as the "Not Available" values are coerced to NAs.
    # as.character() to coerce number back to a character since our original column contains characters
    # todo: indexing the returned sorted vector by [1] turns 12.0 to 12. Fix this
    
    lowest_mortality_rate <- as.character(sort(as.numeric(states[, col_name]))[1])
    
    hospital_names <- states[states[col_name] == lowest_mortality_rate, ]$Hospital.Name

    hospital_names
}

best("TX", "heart attack") 
best("TX", "heart failure") 
best("MD", "pneumonia") 

#  "CYPRESS FAIRBANKS MEDICAL CENTER"
# "FORT DUNCAN MEDICAL CENTER"
# "JOHNS HOPKINS HOSPITAL, THE"
