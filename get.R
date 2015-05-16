# Gather Data with functions here
library(dplyr)
library(tidyr)

get_movie_reviews <- function(n = 1000){
  data <- readLines("data/movies.txt", n = n)
  data <- data.frame(text = data) 
  data <- data %>%
            mutate(text = as.character(text)) %>%
            filter(nchar(text) > 0) %>%
            extract(text, into=c('key', 'value'), '(.*):\\s+(.*)+')
  
  index <- 0
  data$id <- 0
  for(i in 1:nrow(data)){
    if(data$key[[i]] == "product/productId"){
      index <- index + 1
    }
    data$id[[i]] <- index
  }
  
  data <- data %>%
        spread(key, value)
  
  return(data)
}