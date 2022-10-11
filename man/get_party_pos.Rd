\docType{data}
\name{get_party_pos}
\alias{get_party_pos}
\title{Positions of Swiss parties overtime}

\format{
A data frame with 2934 rows and 13 variables:
\describe{
    \item{Party}{Variable with party short names in German}
    \item{PartyFr}{Variable with party short names in French}
    \item{PartyName}{Variable with party full names in German}
    \item{PartyNameFr}{Variable with party full names in French}
    \item{Year}{Variable with the year in numeric form}
    \item{Pos50}{50th percentil of the posterior estimate of party position. Can be used as a reference point for the party position}
    \item{Pos2.5}{2.5th percentil of the posterior estimate of party position.}
    \item{Pos5}{5th percentil of the posterior estimate of party position.}
    \item{Pos25}{25th percentil of the posterior estimate of party position.}
    \item{Pos75}{75th percentil of the posterior estimate of party position.}
    \item{Pos95}{95th percentil of the posterior estimate of party position.}
    \item{Pos97.5}{97.5th percentil of the posterior estimate of party position.}
    \item{Pos50.chain1}{50th percentil of the posterior estimate of party position of the first chain.}
    \item{Pos2.5.chain1}{2.5th percentil of the posterior estimate of party position of the first chain.}
    \item{Pos5.chain1}{5th percentil of the posterior estimate of party position of the first chain.}
    \item{Pos95.chain1}{95th percentil of the posterior estimate of party position of the first chain.}
    \item{Pos97.5.chain1}{97.5th percentil of the posterior estimate of party position of the first chain.}
    \item{Pos50.chain2}{50th percentil of the posterior estimate of party position of the second chain.}
    \item{Pos2.5.chain2}{2.5th percentil of the posterior estimate of party position of the second chain.}
    \item{Pos5.chain2}{5th percentil of the posterior estimate of party position of the second chain.}
    \item{Pos95.chain2}{95th percentil of the posterior estimate of party position of the second chain.}
    \item{Pos97.5.chain2}{97.5th percentil of the posterior estimate of party position of the second chain.}
    \item{Pos50.chain3}{50th percentil of the posterior estimate of party position of the third chain.}
    \item{Pos2.5.chain3}{2.5th percentil of the posterior estimate of party position of the third chain.}
    \item{Pos5.chain3}{5th percentil of the posterior estimate of party position of the third chain.}
    \item{Pos95.chain3}{95th percentil of the posterior estimate of party position of the third chain.}
    \item{Pos97.5.chain3}{97.5th percentil of the posterior estimate of party position of the third chain.}
    \item{Pos50.chain4}{50th percentil of the posterior estimate of party position of the fourth chain.}
    \item{Pos2.5.chain4}{2.5th percentil of the posterior estimate of party position of the fourth chain.}
    \item{Pos5.chain4}{5th percentil of the posterior estimate of party position of the fourth chain.}
    \item{Pos95.chain4}{95th percentil of the posterior estimate of party position of the fourth chain.}
    \item{Pos97.5.chain4}{97.5th percentil of the posterior estimate of party position of the fourth chain.}
}
}


\usage{
get_party_pos(party=NA, year=NA)
}


\arguments{
\item{party}{Character vector indicating which party should appear in the dataset. Default is \code{NA} -which select all parties- but can be equal to \code{CVP}, \code{FDP}, \code{SP}, \code{GPS} and \code{SVP}}

\item{year}{Character vector indicating which year should appear in the dataset. Default is \code{NA} -which select all year- but years between 1970 and 2022 can be specified}

}
\value{
  
}
\description{
Loads a dataset with the positions of Swiss parties based on the posterior quantiles of a  Dynamic Bayesian Item-Response Theory model.
}
\examples{
## Loads the positions of the five parties for all years
data <- get_party_pos() 

## Loads the positions of the CVP, FDP and CVP between 2000 and 2005
data <- get_party_pos(party = c("CVP", "FDP", "SVP"), 
                      year = c(2000:2005)) 
}