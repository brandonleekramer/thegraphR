#' Generate approve action command for Indexer allocations.
#'
#' @param actions Add numbers with first and last total separated by colon (:).
#'
#' @return A string to approve Indexer allocation actions.
#' @export
#'
#' @examples
#' #graph indexer actions queue allocate deployment_id grt_amount --network arbitrum-one
#' approve_actions(1:4)
#'
approve_actions = function(actions){
  cat("graph indexer actions approve", c(actions),"--network arbitrum-one","\n")
  cat("graph indexer actions execute approved")
}
