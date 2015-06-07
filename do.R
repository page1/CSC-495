# Run all the other files with functions here
source("get.R")
source("munge.R")
source("analyze.R")
library(sand)

main <- function(){
  Rdata_file <- "data/movie_movie_projection.Rdata"
  
  if(file.exists(Rdata_file)){
    load(Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    
    data$review.time = as.Date(as.POSIXct(as.numeric(data$review.time), origin="1970-01-01"))
    #Data for the year 1998
    data1998 = data[which(data$review.time < as.Date("1999-1-1") & data$review.time > as.Date("1998-1-1")),]
    #Data for the year 1999 (6 months)
    data1999 = data[which(data$review.time < as.Date("1999-6-1") & data$review.time >= as.Date("1999-1-1")),]
    
    
    full_graph1998 <- make_review_graph(data1998)
    projection1998 <- make_movie_movie_projection(full_graph1998)
    full_graph1999 <- make_review_graph(data1999)
    projection1999 <- make_movie_movie_projection(full_graph1999)
    
    #Attach the review scores to the projection
    projection1998 = attach_review_score(projection1998,data1998)
    projection1999 = attach_review_score(projection1999,data1999)
    
    save(projection1998, projection1999, file = Rdata_file)
  }
  
  # write.graph(projection, file = "data/movie_movie_projection.graphml", format = "graphml")
  write.graph(projection1998, file = "data/movie_movie_projection1998.graphml", format = "graphml")
  write.graph(projection1999, file = "data/movie_movie_projection1999.graphml", format = "graphml")
  
  make_plots(projection1998)
  make_plots(projection1999)
  
  return(NULL)
}
