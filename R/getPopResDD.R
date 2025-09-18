#' Loads or downloads and formats the latest dataset on municipal results for direct democratic ballots
#'
#' This function downloads the latest dataset for municipal results in Swiss National
#' direct democratic ballots. These results are available for municipalities, districts,
#' cantons, and the country since 1960. The function downloads, formats and merges and merges different files
#' which can take a few seconds.
#'
#' @param PlaceType Indicates the geographical level(s) that should be extracted from the data. Default value is 'All' which returns results at the National, Cantonal, District and Municipality levels. Can take value 'Country', 'Canton', 'District', or 'Municipality', which return the result for the geographical level indicated.
#' @param Download.OFS Indicates whether you want to download the latest version of the data from the OFS or use the data in the package directly. The downloaded data takes a minute to load and format, dpending on your connection. 
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

getPopResDD <- function(PlaceType = "All", Download.OFS = F) {

  if (length(PlaceType)==0) {
    stop("Error: PlaceType cannot be empty. It must indicate one of the following: 'All', 'Country', 'Catnon', 'District', 'Municipality'")
  }

  if (!(PlaceType %in% c("All", "Country", "Canton", "District", "Municipality"))) {
    stop("Error: PlaceType must indicate one of the following: 'All', 'Country', 'Catnon', 'District', 'Municipality'")
  }

  if (is.logical(Download.OFS)==F) {
    stop("Error: Download.OFS must be logical.")
  }

  if (Download.OFS==F) {
    data("Data_mun1")
    data("Data_mun2")
    data_mun <- cbind(data_mun1, data_mun2)
    rm(list="data_mun1")
    rm(list="data_mun2")
  }

  if (Download.OFS==T) {
    px_data <- pxR::read.px(file = url("https://dam-api.bfs.admin.ch/hub/api/dam/assets/32426125/master"), encoding = "UTF-8")
    data_mun <- as.data.frame(px_data)

    data_mun <- as.data.frame(list(DateName = data_mun[data_mun$Ergebnis=="Ja in %",]$Datum.und.Vorlage,
                                   Place = data_mun[data_mun$Ergebnis=="Ja in %",]$Kanton.......Bezirk........Gemeinde.........,
                                   YesPercent = data_mun[data_mun$Ergebnis=="Ja in %",]$value,
                                   YesVote = data_mun[data_mun$Ergebnis=="Ja",]$value,
                                   NoVote = data_mun[data_mun$Ergebnis=="Nein",]$value,
                                   Voters = data_mun[data_mun$Ergebnis=="Stimmberechtigte",]$value,
                                   ReceivedBallots = data_mun[data_mun$Ergebnis=="Abgegebene Stimmen",]$value,
                                   Participation = data_mun[data_mun$Ergebnis=="Beteiligung in %",]$value,
                                   ValidBallots = data_mun[data_mun$Ergebnis=="Gültige Stimmzettel",]$value))


    data_json <- suppressWarnings(rjson::fromJSON(paste(readLines("https://www.pxweb.bfs.admin.ch/api/v1/fr/px-x-1703030000_101/px-x-1703030000_101.px"), collapse="")))
    muni_id <- as.data.frame(list(NumberMun = data_json[["variables"]][[1]][["values"]],
                                  Place = data_json[["variables"]][[1]][["valueTexts"]]))

    valid_items <- which(as.Date(substr(data_json[["variables"]][[2]][["valueTexts"]], 1, 10)) %in% as.Date(substr(levels(data_mun$DateName), 1, 10)))
    project_id <- as.data.frame(list(anr = data_json[["variables"]][[2]][["values"]][valid_items],
                                     DateName = levels(data_mun$DateName)))



    data_mun$PlaceType <- NA
    data_mun[substr(data_mun$Place, 1, 1)=="S",]$PlaceType <- "Country"
    data_mun[substr(data_mun$Place, 1, 1)=="-",]$PlaceType <- "Canton"
    data_mun[substr(data_mun$Place, 1, 1)==">",]$PlaceType <- "Disctrict"
    data_mun[substr(data_mun$Place, 1, 1)==".",]$PlaceType <- "Municipality"

    muni_id[muni_id$Place=="Suisse",]$Place <- "Schweiz"

    data_mun <- merge(data_mun, muni_id, by = "Place")
    data_mun <- merge(data_mun, project_id, by = "DateName")



    data_mun$Date <- as.Date(substr(data_mun$DateName, 1, 10))
    data_mun$Year <- as.numeric(substr(data_mun$DateName, 1, 4))

    data_mun[nchar(data_mun$NumberMun)>4,]$NumberMun <- substr(data_mun[nchar(data_mun$NumberMun)>4,]$NumberMun,
                                                               nchar(data_mun[nchar(data_mun$NumberMun)>4,]$NumberMun) - 3,
                                                               nchar(data_mun[nchar(data_mun$NumberMun)>4,]$NumberMun))

    data_mun$anr.Swissvotes <- as.numeric(data_mun$anr)/10
    data_mun$YesPercent <- as.numeric(as.character(data_mun$YesPercent))
  }

  if (PlaceType=="Country") {
    data_mun <- data_mun[data_mun$PlaceType=="Country",]
  }
  if (PlaceType=="Canton") {
    data_mun <- data_mun[data_mun$PlaceType=="Canton",]
  }
  if (PlaceType=="District") {
    data_mun <- data_mun[data_mun$PlaceType=="Disctrict",]
  }
  if (PlaceType=="Municipality") {
    data_mun <- data_mun[data_mun$PlaceType=="Municipality",]
  }



  return(data_mun)
}




