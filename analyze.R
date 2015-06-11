# Analyze the data with functions here
library(sand)

compute_descriptive_stats <- function(graph){
  degree_dist <- degree(graph)
  degree_strength <- graph.strength(graph)
  evcentrality <- evcent(graph)$vector
  closeness <- closeness.estimate(graph, cutoff = 20)
  
  transitivity <- transitivity(graph, type="local")
  
  return(list(degree_dist = degree_dist,
              degree_strength = degree_strength,
              evcentrality = evcentrality,
              transitivity = transitivity))
}

make_plots <- function(graph){
  par(mfrow=c(2,2))
  hist(degree(graph),
       main = "Degree Distribution",
       xlab = "Degree",
       breaks = 100)
  
  hist(graph.strength(graph),
       main = "Graph Strength Distribution",
       xlab = "Graph Strength",
       breaks = 100)
  
  hist(evcent(graph)$vector,
       main = "Eigenvector Centrality Distribution",
       xlab = "Eigenvector",
       breaks = 100)
  par(mfrow=c(1,1))
}