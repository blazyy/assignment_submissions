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
        
    # as.vector(t(states[col_name])) is needed because indexing using [] returned dataframes which I need to convert to a vector to use.
    # t() converts a dataframe into a matrix and as.vector() does as the name implies/
    # as.numeric because sorting needs to be done
    
    # WARNING: DOES NOT WORK FOR best("MD", "pneumonia")
    # Although works with best("TX", "heart attack") and best("TX", "heart failure") 
    
    states <- outcome_df[outcome_df$State == state, ]
    lowest_death_rate <- sort(as.numeric(as.vector(t(states[col_name]))))[1]
    all_death_rates <- as.vector(t(states[col_name]))
    hospitals <- states[all_death_rates == lowest_death_rate, ]['Hospital.Name']
    #hospitals <- hospitals[complete.cases(hospitals), ]['Hospital.Name'] 

    hospitals
}