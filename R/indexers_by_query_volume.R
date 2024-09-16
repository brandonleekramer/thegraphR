#' Function returns Indexers ranked by query volume.
#'
#' @param unix_daystart Add your API key.
#' @param n_skip Number of records to skip in GraphQL query records.
#' @param n_retries Number of times to retry after 504 errors.
#' @param my_api_key Add your API key.
#'
#' @return Returns Indexers ranked by query volume.
#' @export
#'
indexers_by_query_volume = function(unix_daystart,
                                    n_skip,
                                    n_retries,
                                    my_api_key){

  my_query = stringr::str_c('{
    indexers(
        skip:',n_skip,',
        first: 1000,
        orderBy: id,
        orderDirection: asc) {
      id
      indexerDailyDataPoints(
        orderBy: query_count,
        orderDirection: desc,
        where: {dayStart_gt: "',unix_daystart,'"}
      ) {
        dayStart
        subgraph_deployment_ipfs_hash
        query_count
        total_query_fees
        avg_query_fee
        chain_id
        }
      }
    }')

  load(file = "data/indexers.rda")

  output = retry::retry(query_subgraph(graphql_query = my_query,
                                       subgraph_id = "Dtr9rETvwokot4BSXaD5tECanXfqfJKcvHuaaEgPDD2D",
                                       api_key = my_api_key),
                        when = "504", max_tries = n_retries)
  output = output$indexers
  output = tidyr::unnest_longer(
    output,indexerDailyDataPoints,indices_include = FALSE) %>%
    tidyr::unnest(indexerDailyDataPoints) %>%
    dplyr::rename(queries_served = query_count) %>%
    dplyr::mutate(queries_served = round(as.numeric(queries_served),8),
                  avg_query_fee_grt =  round(as.numeric(avg_query_fee),8),
                  total_query_fees =  round(as.numeric(total_query_fees),5)) %>%
    dplyr::rename(wallet_address = id,
                  total_query_fees_grt = total_query_fees) %>%
    dplyr::left_join(indexers, by = "wallet_address") %>%
    dplyr::select(dayStart, indexer_name, wallet_address,
                  subgraph_deployment_ipfs_hash, everything(),-avg_query_fee)

  output
}
