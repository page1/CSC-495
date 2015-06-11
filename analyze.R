# Analyze the data with functions here
library(sand)

compute_descriptive_stats <- function(graph){
  degree_dist <- degree(graph)
  degree_strength <- graph.strength(graph)
  evcentrality <- evcent(graph)$vector
  
  transitivity <- transitivity(graph, type="local")
  
  return(list(degree_dist = degree_dist,
              degree_strength = degree_strength,
              evcentrality = evcentrality,
              transitivity = transitivity))
}