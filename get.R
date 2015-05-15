# Gather Data with functions here
library(dplyr)
library(tidyr)

get_movie_reviews <- function(){
  data <- readLines("data/movies.txt", n = 10)
  data <- data.frame(text = data) 
  data$text <- as.character(data$text)
  data <- filter(data, text != "")
  data <- data %>%
            separate(text, c("key", "value"), sep = "^[^:]+:\\s*", error = "drop")
  
  gsub("/^(.+?):", "!@!", data$text) # This needs help.
}