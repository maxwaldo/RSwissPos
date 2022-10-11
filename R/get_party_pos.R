

get_party_pos <- function(party=NA, year=NA) {
  
  if(!is.na(party) & !party %in% c("CVP", "FDP", "SVP", "SP", "GPS")) stop("Wrong party name. Please use: CVP, FDP, SVP, SP or GPS as party name")
  
  if(!is.na(year) & class(year)!="numeric") stop("year argument needs to be numeric.")
  
  if(year>2020|year<1970) stop("year needs to be between 1970 and 2020")
  
  load("data/Parties' position over time.Rda")
  
  if (is.na(year) & is.na(party)) {
    
    return(data_party)
    
  }
  
  if(!is.na(year) & is.na(party)) {
    
    data_party <- data_party[data_party$year %in% year,]
    
  }
  
  if(is.na(year) & !is.na(party)) {
    
    data_party <- data_party[data_party$party %in% party,]
    
  }
  
  if(!is.na(year) & !is.na(party)) {
    
    data_party <- data_party[data_party$party %in% party & data_party$year %in% year,]
    
  }
  
  
}
