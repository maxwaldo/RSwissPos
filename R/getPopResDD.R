#' Downloads and formats the latest dataset on municipal results for direct democratic ballots
#'
#' This function downloads the latest dataset for municipal results in Swiss National
#' direct democratic ballots. These results are available for municipalities, districts,
#' cantons, and the country since 1960. The function downloads, formats and merges and merges different files
#' which can take a few seconds.
#'
#' @param PlaceType Indicates the geographical level(s) that should be extracted from the data. Default value is 'All' which returns results at the National, Cantonal, District and Municipality levels. Can take value 'Country', 'Canton', 'District', or 'Municipality', which return the result for the geographical level indicated.
#' @return A dataset with geographical level and ballot as the unit of analysis.
#' @format A data.frame object with 15 variables:
#' \describe{
#'   \item{DateName}{Date and title of the ballot.}
#'   \item{Place}{Geographical unit's name.}
#'   \item{YesPercent}{Percentage of Yes vote for the ballot in the geographical unit.}
#'   \item{YesVote}{Number of Yes vote for the ballot in the geographical unit.}
#'   \item{NoVote}{Number of No vote for the ballot and the geographical unit.}
#'   \item{Voters}{Number of registered voters in the geographical unit at the time of the ballot}
#'   \item{ReceivedBallots}{Number of ballot received for the ballot in the geographical unit}
#'   \item{Participation}{Participation in percent for the ballot in the geographical unit}
#'   \item{ValidBallotsh}{Number of Valid ballots for the ballot in the geographical unit}
#'   \item{PlaceType}{Geographical level of the geographical unit. Take values "Country", "Canton", "District", or "Municipality"}
#'   \item{NumberMun}{Geographical unit's unique identifier.}
#'   \item{anr}{Ballot's unique identifier.}
#'   \item{Date}{Date of the Ballot.}
#'   \item{Year}{Year of the Ballot.}
#'   \item{anr.Swissvotes}{Ballot's unique identifier for the Swissvotes dataset.}
#' }
#'
#' @examples
#' data_country <- getPopResDD(PlaceType = "Country") ### Gets national support for direct democratic ballots
#'
#' data_mun <- getPopResDD(PlaceType = "Municipality") ### Gets municipal support for direct democratic ballots
#'
#' @export

getPopResDD <- function(PlaceType = "All") {

  if (length(PlaceType)==0) {
    stop("Error: PlaceType cannot be empty. It must indicate one of the following: 'All', 'Country', 'Catnon', 'District', 'Municipality'")
  }

  if (!(PlaceType %in% c("All", "Country", "Canton", "District", "Municipality"))) {
    stop("Error: PlaceType must indicate one of the following: 'All', 'Country', 'Catnon', 'District', 'Municipality'")
  }

  px_data <- pxR::read.px(file = url("https://dam-api.bfs.admin.ch/hub/api/dam/assets/32426125/master"), encoding = "UTF-8")
  data_muni <- as.data.frame(px_data)

  data_muni <- as.data.frame(list(DateName = data_muni[data_muni$Ergebnis=="Ja in %",]$Datum.und.Vorlage,
                                  Place = data_muni[data_muni$Ergebnis=="Ja in %",]$Kanton.......Bezirk........Gemeinde.........,
                                  YesPercent = data_muni[data_muni$Ergebnis=="Ja in %",]$value,
                                  YesVote = data_muni[data_muni$Ergebnis=="Ja",]$value,
                                  NoVote = data_muni[data_muni$Ergebnis=="Nein",]$value,
                                  Voters = data_muni[data_muni$Ergebnis=="Stimmberechtigte",]$value,
                                  ReceivedBallots = data_muni[data_muni$Ergebnis=="Abgegebene Stimmen",]$value,
                                  Participation = data_muni[data_muni$Ergebnis=="Beteiligung in %",]$value,
                                  ValidBallots = data_muni[data_muni$Ergebnis=="Gültige Stimmzettel",]$value))


  data_json <- suppressWarnings(rjson::fromJSON(paste(readLines("https://www.pxweb.bfs.admin.ch/api/v1/fr/px-x-1703030000_101/px-x-1703030000_101.px"), collapse="")))
  muni_id <- as.data.frame(list(NumberMun = data_json[["variables"]][[1]][["values"]],
                                Place = data_json[["variables"]][[1]][["valueTexts"]]))

  valid_items <- which(as.Date(substr(data_json[["variables"]][[2]][["valueTexts"]], 1, 10)) %in% as.Date(substr(levels(data_muni$DateName), 1, 10)))
  project_id <- as.data.frame(list(anr = data_json[["variables"]][[2]][["values"]][valid_items],
                                   DateName = levels(data_muni$DateName)))



  data_muni$PlaceType <- NA
  data_muni[substr(data_muni$Place, 1, 1)=="S",]$PlaceType <- "Country"
  data_muni[substr(data_muni$Place, 1, 1)=="-",]$PlaceType <- "Canton"
  data_muni[substr(data_muni$Place, 1, 1)==">",]$PlaceType <- "Disctrict"
  data_muni[substr(data_muni$Place, 1, 1)==".",]$PlaceType <- "Municipality"

  if (PlaceType=="Country") {
    data_muni <- data_muni[data_muni$PlaceType=="Country",]
  }
  if (PlaceType=="Canton") {
    data_muni <- data_muni[data_muni$PlaceType=="Canton",]
  }
  if (PlaceType=="District") {
    data_muni <- data_muni[data_muni$PlaceType=="Disctrict",]
  }
  if (PlaceType=="Municipality") {
    data_muni <- data_muni[data_muni$PlaceType=="Municipality",]
  }

  data_muni <- merge(data_muni, muni_id, by = "Place")
  data_muni <- merge(data_muni, project_id, by = "DateName")



  data_muni$Date <- as.Date(substr(data_muni$DateName, 1, 10))
  data_muni$Year <- as.numeric(substr(data_muni$DateName, 1, 4))

  data_muni[nchar(data_muni$NumberMun)>4,]$NumberMun <- substr(data_muni[nchar(data_muni$NumberMun)>4,]$NumberMun,
                                                                 nchar(data_muni[nchar(data_muni$NumberMun)>4,]$NumberMun) - 3,
                                                                 nchar(data_muni[nchar(data_muni$NumberMun)>4,]$NumberMun))

  data_muni$anr.Swissvotes <- as.numeric(data_muni$anr)/10
  data_muni$YesPercent <- as.numeric(as.character(data_muni$YesPercent))

  return(data_muni)
}




