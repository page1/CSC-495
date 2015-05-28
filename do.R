# Run all the other files with functions here
source("get.R")
source("munge.R")
library(sand)

main <- function(){
  Rdata_file <- "data/movie_movie_projection.Rdata"
  
  if(file.exists(Rdata_file)){
    load(Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    full_graph <- make_review_graph(data)
    projection <- make_movie_movie_projection(full_graph)
    save(projection, file = Rdata_file)
  }
  
  write.graph(projection, file = "data/movie_movie_projection.graphml", format = "graphml")
  
  return(NULL)
}