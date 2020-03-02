rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Check that state and outcome are valid
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
    
    # Getting required states, converting to numeric, and removing NAs
    states <- outcome_df[outcome_df['State'] == state, ]
    states[, col_name] <- as.numeric(states[, col_name])
    states <- states[!is.na(states[, col_name]), ]
    
    # Check if rank is valid, and use correct numbers depending on "best" or "worst"
    if(num == 'best')
        num <- 1
    else if(num == 'worst')
        num <- nrow(states)
    else if(num > nrow(states))
        return(NA)
    
    # Ordering by hospital rating and hospital name, in that order.
    ordered_states <- states[order(states[col_name], states['Hospital.Name']), ]
    # Getting nth hospital from ordered states. This is the rank.
    hospitals <- ordered_states[, 'Hospital.Name'][num]
    hospitals

}

rankhospital("TX", "heart failure", 4)      # "DETAR HOSPITAL NAVARRO
rankhospital("MD", "heart attack", "worst") # "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)    # NA
