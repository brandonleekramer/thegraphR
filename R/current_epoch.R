


current_epoch = function(my_api_key){
  dataOutputQuery = "query MyQuery { graphNetworks { currentEpoch }}"
  dataOutput = query_subgraph(graphql_query = dataOutputQuery,
                              subgraph_id = "DZz4kDTdmzWLWsV373w2bSmoar3umKKH9y82SUKr5qmp",
                              api_key = my_api_key)
  dataOutput$graphNetworks$currentEpoch
}