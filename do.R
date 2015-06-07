# Run all the other files with functions here
source("get.R")
source("munge.R")
source("analyze.R")
library(sand)

main <- function(){
  projection_Rdata_file <- "data/movie_movie_projection.Rdata"
  
  projection2008 <- NULL
  projection2009 <- NULL
  
  if(file.exists(projection_Rdata_file)){
    load(projection_Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    data$review.time <- as.Date(as.POSIXlt(as.numeric(data$review.time), origin = "1970-01-01"))
    
    # Get Subset of Data
    data2008 <- data[which(data$review.time < as.Date("2009-1-1") & data$review.time > as.Date("2008-1-1")),]
    data2009 <- data[which(data$review.time < as.Date("2009-6-1") & data$review.time >= as.Date("2009-1-1")),]
    
    # Make Graphs
    full_graph2008 <- make_review_graph(data2008)
    projection2008 <- make_movie_movie_projection(full_graph2008)
    full_graph2009 <- make_review_graph(data2009)
    projection2009 <- make_movie_movie_projection(full_graph2009)
    
    #Attach the review scores to the projection
    projection2008 <- attach_review_score(projection2008, data2008)
    projection2009 <- attach_review_score(projection2009, data2009)
    
    # Dump Movie ID's
    V(projection2008)$degree_strength <- graph.strength(projection2008)
    V(projection2009)$degree_strength <- graph.strength(projection2009)
    write.csv(V(projection2008)$name[V(projection2008)$degree_strength > 5000], file = "data/2008.csv")
    write.csv(V(projection2009)$name[V(projection2009)$degree_strength > 5000], file = "data/2009.csv")
    
    # Write Graph Files
    write.graph(projection2008, file = "data/movie_movie_projection2008.graphml", format = "graphml")
    write.graph(projection2009, file = "data/movie_movie_projection2009.graphml", format = "graphml")
    
    # Save Graphs for analysis
    save(projection2008, projection2009, file = projection_Rdata_file)
  }
  
  descriptive_Rdata_file <- "data/projection_descriptions.Rdata"
  if(file.exists(descriptive_Rdata_file)){
    load(descriptive_Rdata_file)
  } else {
    description_2008 <- compute_descriptive_stats(projection2008)
    description_2009 <- compute_descriptive_stats(projection2008)
    save(description_2008, description_2009, file = projection_Rdata_file)
  }

  
  return(NULL)
}
