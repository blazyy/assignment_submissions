rankall <- function(outcome, num = "best") {
    ## Read outcome data
    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Check that outcome is valid 
    if(!outcome %in% c("heart attack", "pneumonia", "heart failure"))
        stop('invalid outcome')
    
    if(outcome == "heart attack")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    
    else if(outcome == "heart failure")
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    
    else
        col_name = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    
    outcome_df[, col_name] <- as.numeric(outcome_df[, col_name])
    outcome_df <- outcome_df[!is.na(outcome_df[, col_name]), ]
    
    # Check if rank is valid, and use correct numbers depending on "best" or "worst"
    if(num == 'best')
        num <- 1
    
    return_df <- data.frame('hospital' = character(0), 'state' = character(0), stringsAsFactors = FALSE)
    
    for(name in names(table(outcome_df$State))){
        all_hospitals_in_state <- outcome_df[outcome_df['State'] == name, ]
        
        if(num == 'worst')
            num <- nrow(all_hospitals_in_state)
        else if(num > nrow(all_hospitals_in_state))
            hospital <- NA
        
        # Ordering by hospital rating and hospital name, in that order.
        ordered_hospitals_in_state <- all_hospitals_in_state[order(all_hospitals_in_state[col_name], all_hospitals_in_state['Hospital.Name']), ]
        # Getting nth hospital from ordered states. This is the rank.
        hospital <- ordered_hospitals_in_state[num, 'Hospital.Name']
        return_df[nrow(return_df) + 1, ] <- c(hospital, name)
    }
    return_df
}

tail(rankall("pneumonia", "worst"), 3)
#tail(rankall("heart failure"), 10)
