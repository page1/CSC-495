# Analyze the data with functions here
library(sand)

make_plots <- function(graph){
  hist(degree(graph),
       main = "Degree Distribution",
       xlab = "Degree")
  
  hist(graph.strength(graph),
       main = "Graph Strength Distribution",
       xlab = "Graph Strength")
  
  hist(evcent(graph)$vector,
       main = "Eigenvector Centrality Distribution",
       xlab = "Eigenvector")
}