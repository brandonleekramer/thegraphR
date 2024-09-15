#' Get the current epoch for The Graph protocol.
#'
#' @param my_api_key Add your API key.
#'
#' @return Returns the current epoch for The Graph protocol.
#' @export
#'
#' @examples
#' the_epoch = current_epoch("3a2f2d6ce1672801c3a044139373a287")
#' the_epoch
#' 
current_epoch = function(my_api_key){
  
  output = onchainR::query_subgraph(graphql_query = "query MyQuery { graphNetworks { currentEpoch }}",
                                    subgraph_id = "DZz4kDTdmzWLWsV373w2bSmoar3umKKH9y82SUKr5qmp",
                                    api_key = my_api_key)
  
  output$graphNetworks$currentEpoch
}