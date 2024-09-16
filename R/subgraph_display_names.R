#' Function returns subgraph display names.
#'
#' @param skip Number of records to skip in GraphQL query records.
#' @param first Number of records to return in GraphQL query records.
#' @param my_api_key Add your API key.
#'
#' @return Returns subgraph display names.
#' @export
#'
subgraph_display_names = function(skip, first, my_api_key){

  metadataQuery = str_c('{
    subgraphs(skip:',skip,', first:',first,') {
      metadata {
        displayName
      }
      id
      currentVersion {
        subgraphDeployment {
          manifest {
            id
            network
          }
        }
      }
    }
  }')

  # clean subgraph data
  metadataQuery = query_subgraph(graphql_query = metadataQuery,
                                 subgraph_id = "DZz4kDTdmzWLWsV373w2bSmoar3umKKH9y82SUKr5qmp",
                                 api_key = my_api_key)

  metadataQuery = metadataQuery$subgraphs %>% rename(subgraph_id = id)

  for (var in list("metadata", "currentVersion", "subgraphDeployment", "manifest")){
    metadataQuery = unnest_longer(
      metadataQuery, var, indices_include = FALSE) %>% unnest(var)
  }

  metadataQuery = metadataQuery %>%
    rename(display_name = displayName,
           deployment_id = id) %>%
    filter(!is.na(display_name))

  metadataQuery
}
