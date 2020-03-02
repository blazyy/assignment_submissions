best <- function(state, outcome) {

    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
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
    
    # Getting only the states that we want.
    states <- outcome_df[outcome_df['State'] == state, ]
    # Need to convert to numeric as the column is of type character. When sorting, "11.7" will be greater than "9.7" which we don't want.
    # Will show warnings as the "Not Available" values are coerced to NAs. Ignore. 
    # as.character() to coerce number back to a character since our original column is of type character.
    lowest_mortality_rate <- as.character(sort(as.numeric(states[, col_name]))[1])
    # "12.0" gets converted to "12" when indexing using [1], so need to add ".0" as decimal place using %.1f format in sprintf()
    modded_lmr <- sprintf('%.1f', as.numeric(lowest_mortality_rate))
    # Getting the name of the hospital with the lowest mortality rate. 
    hospital_names <- states[states[col_name] == modded_lmr, ]$Hospital.Name
    hospital_names
}

best("TX", "heart attack")  # "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure") # "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")  # "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")     # "GREATER BALTIMORE MEDICAL CENTER"

