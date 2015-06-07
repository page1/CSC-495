# Run all the other files with functions here
source("get.R")
source("munge.R")
source("analyze.R")
library(sand)

main <- function(){
  Rdata_file <- "data/movie_movie_projection.Rdata"
  
  projection1998 <- NULL
  projection1999 <- NULL
  
  if(file.exists(Rdata_file)){
    load(Rdata_file)
  } else {
    data <- get_min_movie_reviews()
    data$review.time <- as.Date(as.POSIXlt(as.numeric(data$review.time), origin = "1960-01-01"))
    
    # Get Subset of Data
    data1998 <- data[which(data$review.time < as.Date("1999-1-1") & data$review.time > as.Date("1998-1-1")),]
    data1999 <- data[which(data$review.time < as.Date("1999-6-1") & data$review.time >= as.Date("1999-1-1")),]
    
    # Make Graphs
    full_graph1998 <- make_review_graph(data1998)
    projection1998 <- make_movie_movie_projection(full_graph1998)
    full_graph1999 <- make_review_graph(data1999)
    projection1999 <- make_movie_movie_projection(full_graph1999)
    
    # Dump Movie ID's
    write.csv(V(projection1998)$name, file = "data/1998.csv")
    write.csv(V(projection1999)$name, file = "data/1999.csv")
    
    # Write Graph Files
    write.graph(projection1998, file = "data/movie_movie_projection1998.net", format = "pajek")
    write.graph(projection1999, file = "data/movie_movie_projection1999.net", format = "pajek")
    
    # Save Graphs for analysis
    save(projection1998, projection1999, file = Rdata_file)
  }
  
  make_plots(projection1998)
  make_plots(projection1999)
  
  return(NULL)
}