#' Downloads and formats the latest version of the Swissvotes dataset.
#'
#' This function downloads the latest version of the Swissvotes dataset.
#' The data collects information at the ballot level since the first national ballot in 1848.
#' The codebook for the Swissvotes data set can be found here: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784
#' To cite, please use: Swissvotes (Year). Swissvotes – die Datenbank der eidgenössischen Volksabstimmungen.
#' For more information see: https://www.swissvotes.ch
#'
#' @param Column.names Indicates the Column name of interest that should be extracted from the data. Default value is 'All' which returns all the variables. It can take any number of existing column names from the swissvotes dataset.
#' @return A dataset containing diverse information at the ballot level.
#' @format A data.frame object with 874 variables. The complete list of variables, their function and codes are listed in the Codebook available here: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784
#'
#' @examples
#' data_all <- getSwissvotes() ## Gets the Swissvotes data with all the variables
#'
#' data_institutions <- getSwissvotes(c("anr", "rechtsform")) ### Get the direct democratic institutions and the id of the ballot.
#'
#'
#' @export

getSwissvotes <- function(Column.names = "All") {

  if (length(Column.names)==0) {
    stop("Error: Column.names cannot be empty. It must indicate 'All' a vector of names with one or more of the variables in the dataset. The codebook for the Swissvotes data can be found there: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784")
  }


  swissvotes <- read.csv(url("https://swissvotes.ch/page/dataset/swissvotes_dataset.csv"), sep = ";")

  if (any(Column.names %in% c("All", colnames(swissvotes)))==F) {
    stop("Error: Column.names must indicate 'All' a vector of names with one or more of the variables in the dataset. The codebook for the Swissvotes data can be found there: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784")
  }

  if(length(Column.names)>1 & any("All" %in% Column.names)==T) {
    stop("Error: 'All' is not one of the variable name. Either precise 'All' and get all the variables, or chose one of more of the variable name in the dataset. The codebook for the Swissvotes data can be found there: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784")
  }

  message("Please cite: Swissvotes (Year). Swissvotes – die Datenbank der eidgenössischen Volksabstimmungen. ")

  if (length(Column.names)>1) {
    return(swissvotes[,which(colnames(swissvotes) %in% Column.names)])

  } else {
    if (length(Column.names)==1 & Column.names!="All") {
      return(as.data.frame(swissvotes[,which(colnames(swissvotes) %in% Column.names)]))
    } else {
      return(swissvotes)
    }

  }

}








