#' Returns subgraph data from an indexed smart contract on The Graph Network.
#'
#' @param graphql_query A GraphQL query of a subgraph.
#' @param subgraph_id Subgraph ID (found near top of subgraph page on Graph Explorer)
#' @param api_key An API key from Subgraph Studio.
#'
#' @return Returns subgraph data from an indexed smart contract.
#' @export
#'

#'
query_subgraph = function(graphql_query,
                          subgraph_id,
                          api_key){

  graphql_conn <- ghql::GraphqlClient$new(
    url = stringr::str_c("https://gateway.network.thegraph.com/api/subgraphs/id/", subgraph_id),
    headers = list(Authorization = paste0("Bearer ", api_key)))

  qry <- ghql::Query$new()
  qry$query('query_table', graphql_query)
  query_table <- graphql_conn$exec(qry$queries$query_table)
  query_table <- jsonlite::fromJSON(query_table)
  query_table <- query_table$data
  query_table
}


