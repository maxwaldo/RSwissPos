#' Download Swiss administrative boundaries
#'
#' @description
#' Downloads historical administrative boundaries from the
#' Swiss Federal Statistical Office (BFS).
#'
#' Boundaries are available for municipalities, districts,
#' cantons, Switzerland, and lakes for historical states
#' since 1850.
#'
#' @param year Year of the administrative boundaries.
#'   The function retrieves the administrative state on
#'   January 1 of that year.
#'
#' @param type Geographical unit to return. One of
#'   `"Municipality"`, `"District"`, `"Canton"`,
#'   `"Country"`, or `"Lake"`.
#'
#' @param detail Level of geographical detail. Either
#'   `"K4"` or `"G1"`. `"K4"` is the default and is
#'   recommended for maps of Switzerland.
#'
#' @param surface Surface representation. Either `"total"`
#'   or `"vegetation"`. Vegetation surfaces are only
#'   available with `detail = "K4"` for municipalities,
#'   districts, and cantons.
#'
#' @param crs Output coordinate reference system.
#'   Defaults to EPSG 2056 (Swiss LV95).
#'
#' @return An object of class `sf`.
#'
#' @examples
#' municipalities <- getSwissGeo(2025)
#'
#' municipalities_vf <- getSwissGeo(
#'   2025,
#'   surface = "vegetation"
#' )
#'
#' lakes <- getSwissGeo(
#'   2025,
#'   type = "Lake"
#' )
#'
#' @export
getSwissGeo <- function(
    year,
    type = "Municipality",
    detail = "K4",
    surface = "total",
    crs = 2056
) {

  # ------------------------------------------------------------
  # Check arguments
  # ------------------------------------------------------------

  type <- match.arg(
    type,
    c(
      "Municipality",
      "District",
      "Canton",
      "Country",
      "Lake"
    )
  )

  detail <- match.arg(
    detail,
    c("K4", "G1")
  )

  surface <- match.arg(
    surface,
    c("total", "vegetation")
  )

  year <- as.integer(year)

  if (is.na(year) || year < 1850) {
    stop("year must be 1850 or later.")
  }


  # ------------------------------------------------------------
  # Check valid combinations
  # ------------------------------------------------------------

  if (
    surface == "vegetation" &&
    detail != "K4"
  ) {
    stop(
      "Vegetation surfaces are only available ",
      "with detail = 'K4'."
    )
  }

  if (
    surface == "vegetation" &&
    !type %in% c(
      "Municipality",
      "District",
      "Canton"
    )
  ) {
    stop(
      "Vegetation surfaces are only available ",
      "for municipalities, districts, and cantons."
    )
  }

  if (
    type == "Lake" &&
    detail == "G1"
  ) {
    stop(
      "Lake geometries are not available in G1. ",
      "Use detail = 'K4'."
    )
  }


  # ------------------------------------------------------------
  # Construct BFS STAC identifiers
  # ------------------------------------------------------------

  date <- paste0(
    year,
    "-01-01"
  )

  detail_lower <- tolower(detail)

  collection <- paste0(
    "ch.bfs.historisierte-administrative_grenzen_",
    detail_lower
  )

  item <- paste0(
    "historisierte-administrative_grenzen_",
    detail_lower,
    "_",
    date
  )

  stac_url <- paste0(
    "https://data.geo.admin.ch/api/stac/v1/collections/",
    collection,
    "/items/",
    item
  )


  # ------------------------------------------------------------
  # Ask STAC for the actual download URL
  # ------------------------------------------------------------

  stac <- tryCatch(
    jsonlite::fromJSON(
      stac_url,
      simplifyVector = FALSE
    ),
    error = function(e) {
      stop(
        "Could not find BFS boundaries for ",
        year,
        " with detail ",
        detail,
        "."
      )
    }
  )


  # Extract all available assets
  asset_urls <- vapply(
    stac$assets,
    function(x) x$href,
    character(1)
  )


  # Prefer the EPSG 2056 shapefile archive
  download_url <- asset_urls[
    grepl(
      "_2056\\.shp\\.zip$",
      asset_urls,
      ignore.case = TRUE
    )
  ]


  if (length(download_url) == 0) {
    stop(
      "No EPSG 2056 shapefile archive found ",
      "for this BFS boundary dataset."
    )
  }

  download_url <- download_url[1]


  # ------------------------------------------------------------
  # Download archive
  # ------------------------------------------------------------

  temp_zip <- tempfile(
    fileext = ".zip"
  )

  temp_dir <- tempfile()

  dir.create(temp_dir)

  on.exit(
    unlink(
      c(temp_zip, temp_dir),
      recursive = TRUE
    ),
    add = TRUE
  )


  utils::download.file(
    download_url,
    destfile = temp_zip,
    mode = "wb",
    quiet = TRUE
  )


  # ------------------------------------------------------------
  # Extract archive
  # ------------------------------------------------------------

  utils::unzip(
    temp_zip,
    exdir = temp_dir
  )


  # ------------------------------------------------------------
  # Find requested shapefile
  # ------------------------------------------------------------

  shp_files <- list.files(
    temp_dir,
    pattern = "\\.shp$",
    recursive = TRUE,
    full.names = TRUE,
    ignore.case = TRUE
  )


  if (length(shp_files) == 0) {
    stop(
      "No shapefile found in the downloaded archive."
    )
  }


  # BFS naming convention
  bfs_names <- c(
    Municipality = "Communes",
    District     = "Districts",
    Canton       = "Cantons",
    Country      = "Country",
    Lake         = "Lacs"
  )

  target <- bfs_names[type]


  files <- shp_files[
    grepl(
      target,
      basename(shp_files),
      ignore.case = TRUE
    )
  ]


  # ------------------------------------------------------------
  # Select total or vegetation surface
  # ------------------------------------------------------------

  is_vegetation <- grepl(
    "(^|_)vf(_|\\.)",
    basename(files),
    ignore.case = TRUE
  )


  if (surface == "vegetation") {

    files <- files[
      is_vegetation
    ]

  } else {

    files <- files[
      !is_vegetation
    ]

  }


  if (length(files) == 0) {

    stop(
      "Requested geometry was not found in the ",
      "BFS archive."
    )

  }


  # ------------------------------------------------------------
  # Read with sf
  # ------------------------------------------------------------

  geo <- sf::st_read(
    files[1],
    quiet = TRUE
  )


  # ------------------------------------------------------------
  # Transform CRS if requested
  # ------------------------------------------------------------

  if (!is.null(crs)) {

    geo <- sf::st_transform(
      geo,
      crs
    )

  }


  # ------------------------------------------------------------
  # Add useful metadata
  # ------------------------------------------------------------

  geo$Year <- year
  geo$GeoType <- type
  geo$GeoDetail <- detail
  geo$GeoSurface <- surface


  geo
}


