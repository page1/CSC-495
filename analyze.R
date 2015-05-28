# Analyze the data with functions here
library(sand)

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
