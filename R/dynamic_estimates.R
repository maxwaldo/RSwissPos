#' Posterior estimate for ballot proposal of a dynamic Bayesian IRT model
#'
#' Data with posterior estimates of a dynamic Bayesian IRT based on
#' the computation in Walder (2025). This data enables estimating the
#' position of cantons and municipalities on the party competition space.
#'
#' @docType data
#'
#' @usage data(dynamic_estimates)
#'
#' @format A data frame with 453 rows and 6 variables:
#' \describe{
#'   \item{anr}{identification number of the ballot}
#'   \item{Discrimination.2.5}{2.5th percentile of the discrimination parameter posterior estimate}
#'   \item{Discrimination.25}{25th percentile of the discrimination parameter posterior estimate}
#'   \item{Discrimination.50}{50th percentile of the discrimination parameter posterior estimate}
#'   \item{Discrimination.75}{75th percentile of the discrimination parameter posterior estimate}
#'   \item{Discrimination.97.5}{97.5th percentile of the discrimination parameter posterior estimate}
#'}
#' @keywords datasets
#'
#' @references Walder (2025) Latent Ideological Positions of Swiss Parties and Subsets of the Population
#'
#'
#' @examples
#' data(dynamic_estimates)
"dynamic_estimates"
