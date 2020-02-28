best <- function(state, outcome) {

    outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    # if(dim(table(outcome_df$State == 'AZ')) == 1) 
    
    if(!state %in% outcome_df$State)
        stop('invalid state')
    
    if(!outcome %in% c("heart attack", "pneumonia", "heart failure"))
        stop('invalid outcome')
    
    if(outcome == "heart attack"){
        states <- outcome_df[outcome_df$State == state, ]
        lowest_death_rate <- sort(as.numeric(states$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack))[1]
        hospitals <- states[states$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack == lowest_death_rate, ]['Hospital.Name']
        hospitals <- hospitals[complete.cases(hospitals), ]  
    }
        
    else if(outcome == "heart failure"){
        states <- outcome_df[outcome_df$State == state, ]
        lowest_death_rate <- sort(as.numeric(states$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure))[1]
        hospitals <- states[states$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure == lowest_death_rate, ]['Hospital.Name']
        hospitals <- hospitals[complete.cases(hospitals), ]  
    }
    
    else{
        states <- outcome_df[outcome_df$State == state, ]
        lowest_death_rate <- sort(as.numeric(states$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia))[1]
        hospitals <- states[states$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia == lowest_death_rate, ]['Hospital.Name']
        hospitals <- hospitals[complete.cases(hospitals), ]      
    }

    ## Return hospital name in that state with lowest 30-day death
    ## rate
    hospitals
}