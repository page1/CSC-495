# Munge & clean the data with function here
library(sand)

make_review_graph <- function(movie_revie_df){
  graph <- graph.data.frame(movie_revie_df, directed=F)
  V(graph)$type <- (V(graph)$name %in% movie_revie_df$product.productId) #True if its a movie
  
  return(graph)
}

make_movie_movie_projection <- function(full_graph){
  proj_graph <- bipartite.projection(full_graph, which="true")
  
  return(proj_graph)
}

trim_low_graph_strength <- function(graph, min_graph_strength = 10){
  graph <- delete.vertices(graph, graph.strength(graph) < min_graph_strength)
  
  return(graph)
}

attach_review_score <- function(graph,data){
  
  d <- data %>% 
    group_by(product.productId) %>%
    summarize(mean_score = mean(review.score))
  
  for(v in V(graph)){
    name <- get.vertex.attribute(graph, "name", v)
    if (length(name) != 0)
    {
      graph <- set.vertex.attribute(graph, "review", v, d$mean_score[which(d$product.productId == name)])
    }
  }
  return(graph)
}