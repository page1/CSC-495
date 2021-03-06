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

attach_nice_name <- function(graph,nice_name){
  for(v in V(graph)){
    name <- get.vertex.attribute(graph, "name", v)
    if (length(name) != 0 && length(which(nice_name[,2] == name)) != 0)
    {
      graph <- set.vertex.attribute(graph, "nice_name", v, nice_name[which(nice_name[,2] == name),3])
    }
  }
  
  V(graph)$nice_name[is.na(V(graph)$nice_name)] <- ""
  
  return(graph)
}

remove_dups <- function(graph){
  nodes_check_sum <- lapply(V(graph), function(x){
    data.frame(sum = sum(neighbors(graph, x, mode = 1)) + x, 
               node = x)
  }) %>%do.call("rbind", .)
  
  unique_nodes <- nodes_check_sum %>%
    group_by(sum) %>%
    mutate(row_n = row_number()) %>%
    filter(row_n == 1)
  
  not_in_set <- V(graph)[!(V(graph) %in% unique_nodes$node)]
  new_graph <- delete.vertices(graph, not_in_set)
  new_graph <- delete.vertices(new_graph, degree(new_graph) == 0)
  
  return(new_graph)
}