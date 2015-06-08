# Run all the other files with functions here
source("get.R")
source("munge.R")
source("analyze.R")
library(sand)

main <- function(){
  projection_Rdata_file <- "data/movie_movie_projection.Rdata"
  
  projection1998 <- NULL
  projection2000 <- NULL
  
  if(file.exists(projection_Rdata_file)){
    load(projection_Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    data$review.time <- as.Date(as.POSIXlt(as.numeric(data$review.time), origin = "1970-01-01"))
    
    # Get Subset of Data
    data1998 <- data[which(data$review.time < as.Date("2000-1-1") & data$review.time > as.Date("1998-1-1")),]
    data2000 <- data[which(data$review.time < as.Date("2001-1-1") & data$review.time >= as.Date("2000-1-1")),]
    
    # Make Graphs
    full_graph1998 <- make_review_graph(data1998)
    projection1998 <- make_movie_movie_projection(full_graph1998)
    projection1998 <- remove_dups(projection1998)
    
    
    full_graph2000 <- make_review_graph(data2000)
    projection2000 <- make_movie_movie_projection(full_graph2000)
    projection2000 <- remove_dups(projection2000)
    
    #Attach the review scores to the projection
    projection1998 <- attach_review_score(projection1998, data1998)
    projection2000 <- attach_review_score(projection2000, data2000)
    
    nice_names1998 <- read.csv("data/1998-Filtered-Titles.csv", header = F)
    nice_names1998$V2 <- as.character(nice_names1998$V2)
    nice_names1998$V3 <- as.character(nice_names1998$V3)
    projection1998 <- attach_nice_name(projection1998, nice_names1998)
    
    # Dump Movie ID's
    V(projection1998)$degree_strength <- graph.strength(projection1998)
    V(projection2000)$degree_strength <- graph.strength(projection2000)
    write.csv(V(projection1998)$name[V(projection1998)$degree_strength > 20], file = "data/1998.csv")
    write.csv(V(projection2000)$name[V(projection2000)$degree_strength > 20], file = "data/2000.csv")
    
    # Write Graph Files
    write.graph(projection1998, file = "data/movie_movie_projection1998.graphml", format = "graphml")
    write.graph(projection2000, file = "data/movie_movie_projection2000.graphml", format = "graphml")
    
    # Save Graphs for analysis
    save(projection1998, projection2000, file = projection_Rdata_file)
  }
  
  descriptive_Rdata_file <- "data/projection_descriptions.Rdata"
  if(file.exists(descriptive_Rdata_file)){
    load(descriptive_Rdata_file)
  } else {
    description_1998 <- compute_descriptive_stats(projection1998)
    description_2000 <- compute_descriptive_stats(projection2000)
    save(description_1998, description_2000, file = descriptive_Rdata_file)
  }
  
  return(NULL)
}
