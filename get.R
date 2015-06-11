# Gather Data with functions here
library(dplyr)
library(tidyr)
library(stringr)

get_min_movie_reviews <- function(){
  Rdata_file <- "data/movies.min.Rdata"
  
  if(file.exists(Rdata_file)){
    load(Rdata_file)
  } else {
    data <- read.csv(file = "data/movies.min.csv", quote="", stringsAsFactors=FALSE)
    save(data, file = Rdata_file)
  }
  
  return(data)
}