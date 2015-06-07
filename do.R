# Run all the other files with functions here
source("get.R")
source("munge.R")
source("analyze.R")
library(sand)

main <- function(){
  projection_Rdata_file <- "data/movie_movie_projection.Rdata"
  
  projection1998 <- NULL
  projection1999 <- NULL
  
  if(file.exists(projection_Rdata_file)){
    load(projection_Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    data$review.time <- as.Date(as.POSIXlt(as.numeric(data$review.time), origin = "1970-01-01"))
    
    # Get Subset of Data
    data1998 <- data[which(data$review.time < as.Date("1999-1-1") & data$review.time > as.Date("1998-1-1")),]
    data1999 <- data[which(data$review.time < as.Date("1999-6-1") & data$review.time >= as.Date("1999-1-1")),]
    
    # Make Graphs
    full_graph1998 <- make_review_graph(data1998)
    projection1998 <- make_movie_movie_projection(full_graph1998)
    full_graph1999 <- make_review_graph(data1999)
    projection1999 <- make_movie_movie_projection(full_graph1999)
    
    #Attach the review scores to the projection
    projection1998 <- attach_review_score(projection1998, data1998)
    projection1999 <- attach_review_score(projection1999, data1999)
    
    # Dump Movie ID's
    V(projection1998)$degree_strength <- graph.strength(projection1998)
    V(projection1999)$degree_strength <- graph.strength(projection1999)
    write.csv(V(projection1998)$name[V(projection1998)$degree_strength > 5000], file = "data/1998.csv")
    write.csv(V(projection1999)$name[V(projection1999)$degree_strength > 5000], file = "data/1999.csv")
    
    # Write Graph Files
    write.graph(projection1998, file = "data/movie_movie_projection1998.graphml", format = "graphml")
    write.graph(projection1999, file = "data/movie_movie_projection1999.graphml", format = "graphml")
    
    # Save Graphs for analysis
    save(projection1998, projection1999, file = projection_Rdata_file)
  }
  
  descriptive_Rdata_file <- "data/projection_descriptions.Rdata"
  if(file.exists(descriptive_Rdata_file)){
    load(descriptive_Rdata_file)
  } else {
    description_1998 <- compute_descriptive_stats(projection1998)
    description_1999 <- compute_descriptive_stats(projection1999)
    save(description_1998, description_1999, file = projection_Rdata_file)
  }

  
  return(NULL)
}
