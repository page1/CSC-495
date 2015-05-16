# Gather Data with functions here
library(dplyr)
library(tidyr)

get_movie_reviews <- function(){
  data <- readLines("data/movies.txt", n = 1000)
  data <- data.frame(text = data) 
  data <- data %>%
            mutate(text = as.character(text)) %>%
            filter(nchar(text) > 0)

  d <- data %>%
        extract(text, into=c('key', 'value'), '(.*):\\s+(.*)+')
  
  index <- 0
  d$id <- 0
  for(i in 1:nrow(d)){
    if(d$key[[i]] == "product/productId"){
      index <- index + 1
    }
    d$id[[i]] <- index
  }
}