#' Function to acquire allocation data from an Indexer.
#'
#' @param wallet_address Wallet address of Indexer to obtain allocation data from.
#' @param my_api_key Add your API key.
#'
#' @return Returns allocations from specified Indexer.
#' @export
#'
allocations_by_indexer = function(wallet_address, my_api_key){

  data_query = str_c('{
    indexers(
      first: 1000
      orderBy: allocationCount
      orderDirection: desc
      where: {id: "',wallet_address,'"}
    ) {
    allocations(first: 1000, orderBy: allocatedTokens) {
        id
        allocatedTokens
        subgraphDeployment {
          ipfsHash
          signalledTokens
          stakedTokens
          versions {
            subgraph {
              id
            }
          }
        }
        createdAtEpoch
      }
    }
  }')

  data_output = query_subgraph(graphql_query = data_query,
                               subgraph_id = "DZz4kDTdmzWLWsV373w2bSmoar3umKKH9y82SUKr5qmp",
                               api_key = my_api_key)
  data_output = as.data.frame(data_output$indexers) %>%
    unnest(allocations) %>%
    rename(allocation_id = id) %>%
    unnest(subgraphDeployment) %>%
    unnest(versions) %>%
    unnest(subgraph) %>%
    rename(subgraph_id = id) %>%
    mutate(allocatedTokens = as.numeric(allocatedTokens)/(10^18),
           signalledTokens = as.numeric(signalledTokens)/(10^18),
           stakedTokens = as.numeric(stakedTokens)/(10^18),
           allocatedTokens = round(allocatedTokens, 2),
           signalledTokens = round(signalledTokens, 2),
           stakedTokens = round(stakedTokens, 2)) %>%
    rename(deployment_id = ipfsHash,
           allocated_tokens = allocatedTokens,
           signalled_tokens = signalledTokens,
           staked_tokens = stakedTokens) %>%
    select(deployment_id, allocated_tokens, signalled_tokens,
           staked_tokens, subgraph_id, allocation_id, createdAtEpoch) %>%
    arrange(desc(allocated_tokens))

  data_output
}

# query_allocationsByIndexer gets first 1000 current allocations for Indexer wallet address
# TODO: Add autopagination and subgraph names to this query
