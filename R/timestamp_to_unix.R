#' Get the unix from a timestamp.
#'
#' @param timestamp Add a timestamp.
#'
#' @return Returns the unix from a timestamp.
#' @export
#'
#' @examples
#' timestamp = "2024-09-14"
#' the_unix = timestamp_to_unix(timestamp)
#' the_unix
#'
timestamp_to_unix = function(timestamp){
  as.numeric(as.POSIXct((as.Date(timestamp, format="%d/%m/%Y")), format="%Y-%m-%d"))
}
