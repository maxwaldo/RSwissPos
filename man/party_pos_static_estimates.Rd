% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/party_pos_static_estimates.R
\docType{data}
\name{party_pos_static_estimates}
\alias{party_pos_static_estimates}
\title{Posterior estimate for parties' positions of a static Bayesian IRT model}
\format{
A data frame with 5 rows and 6 variables:
\describe{
  \item{party}{The political party for which the position is computed}
  \item{Discrimination.2.5}{2.5th percentile of the discrimination parameter posterior estimate}
  \item{Discrimination.25}{25th percentile of the discrimination parameter posterior estimate}
  \item{Discrimination.50}{50th percentile of the discrimination parameter posterior estimate}
  \item{Discrimination.75}{75th percentile of the discrimination parameter posterior estimate}
  \item{Discrimination.97.5}{97.5th percentile of the discrimination parameter posterior estimate}
}
}
\usage{
data(party_pos_static_estimates)
}
\description{
Data with posterior estimates of a static Bayesian IRT based on
the computation in Walder (2025). This data gives the static party position
based on party vote recommendation on direct democratic ballots (1960-2020).
}
\examples{
data(party_pos_static_estimates)
}
\references{
Walder (2025) Latent Ideological Positions of Swiss Parties and Subsets of the Population
}
\keyword{datasets}
