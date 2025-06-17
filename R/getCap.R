#' Downloads and formats the latest version of the Comprative Agendas' project dataset on direct democracy.
#'
#' This function downloads the latest version of the Comparative Agenda's project coding of Swiss direct democratic ballots.
#' The data collects information at the ballot level since the first national ballot in 1848.
#' The codebook for the Comparative Agenda's project data set can be found here: https://minio.la.utexas.edu/compagendas/codebookfiles/switzerland_direct_democracy_codebook.pdf
#' To cite, please use the following footnote: "The data used here were originally collected by Roy Gava, Pascal Sciarini, Anke Tresch and Frédéric Varone, with the support of the Swiss National Science Foundation (grant number 105511-119245/1 and project ‘The Mediatization of Political Decision Making’ sponsored as part of the National Center of Competence in Research ‘Challenges to Democracy in the 21st Century’). Neither SNSF nor the original collectors of the data bear any responsibility for the analysis reported here."
#' For more information see: https://www.comparativeagendas.net
#'
#' @param Column.names Indicates the Column name of interest that should be extracted from the data. Default value is 'All' which returns all the variables. It can take any number of existing column names from the Comparative Agenda's project data set.
#' @return A dataset containing diverse information related to the .
#' @format A data.frame object with 17 variables. The complete list of variables, their function and codes are listed in the Codebook available here: https://minio.la.utexas.edu/compagendas/codebookfiles/switzerland_direct_democracy_codebook.pdf
#'
#' @examples
#' CAP <- getCAP() #### Gets all the variables
#' CAP_mal <- getCAP(c("anr", "majortopic")) ### Gets the identification number of the ballot and the majortopic
#'
#'
#' @export

getCAP <- function(Column.names = "All") {

  if (length(Column.names)==0) {
    stop("Error: Column.names cannot be empty. It must indicate 'All' a vector of names with one or more of the variables in the dataset. The codebook for the Swissvotes data can be found there: https://minio.la.utexas.edu/compagendas/codebookfiles/switzerland_direct_democracy_codebook.pdf")
  }

  CAP <- read.csv(url("https://minio.la.utexas.edu/compagendas/datasetfiles/switzerland_direct_democracy.csv"))
  CAP$anr <- c(substr(CAP[1:582,]$source, 12, nchar(CAP$source)),
               substr(CAP[583:605,]$source, 5, 7))

  if (any(Column.names %in% c("All", colnames(CAP))==F)) {
    stop("Error: Column.names must indicate 'All' a vector of names with one or more of the variables in the dataset. The codebook for the Comparative Agenda's project data can be found there: https://minio.la.utexas.edu/compagendas/codebookfiles/switzerland_direct_democracy_codebook.pdf")
  }

  if(length(Column.names)>1 & any("All" %in% Column.names)==T) {
    stop("Error: 'All' is not one of the variable name. Either precise 'All' and get all the variables, or chose one of more of the variable name in the dataset. The codebook for the Comparative Agenda's project data can be found there: https://minio.la.utexas.edu/compagendas/codebookfiles/switzerland_direct_democracy_codebook.pdf")
  }

  message("Please cite using the following footnote: The data used here were originally collected by Roy Gava, Pascal Sciarini, Anke Tresch and Frédéric Varone, with the support of the Swiss National Science Foundation (grant number 105511-119245/1 and project ‘The Mediatization of Political Decision Making’ sponsored as part of the National Center of Competence in Research ‘Challenges to Democracy in the 21st Century’). Neither SNSF nor the original collectors of the data bear any responsibility for the analysis reported here.")

  if (length(Column.names)>1) {
    return(CAP[,which(colnames(CAP) %in% Column.names)])

  } else {
    if (length(Column.names)==1 & Column.names!="All") {
      return(as.data.frame(CAP[,which(colnames(CAP) %in% Column.names)]))
    } else {
      return(CAP)
    }

  }

}






