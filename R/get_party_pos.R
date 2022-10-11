
get_party_pos <- function(party=NA, year=NA) {
  
  if(!is.na(party) & any(party %in% c("CVP", "FDP", "SVP", "SP", "GPS"))) stop("Wrong party name. Please use: CVP, FDP, SVP, SP or GPS as party name")
  
  if(!is.na(year) & class(year)!="numeric") stop("year argument needs to be numeric.")
  
  if(!is.na(year) & (any(year>2022)|any(year<1970))) stop("year needs to be between 1970 and 2020")
  
  data(dataParty)
  
  if (is.na(year) & is.na(party)) {
    
    return(dataParty)
    
  }
  
  if(!is.na(year) & is.na(party)) {
    
    dataParty <- dataParty[dataParty$Year %in% year,]
    return(dataParty)
    
  }
  
  if(is.na(year) & !is.na(party)) {
    
    dataParty <- dataParty[dataParty$Party %in% party,]
    return(dataParty)
    
  }
  
  if(!is.na(year) & !is.na(party)) {
    
    dataParty <- dataParty[dataParty$Party %in% party & dataParty$Year %in% year,]
    return(dataParty)
    
  }
  
  
}
