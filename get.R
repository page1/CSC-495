# Gather Data with functions here
library(dplyr)
library(tidyr)
library(stringr)

get_min_movie_reviews <- function(){
  Rdata_file <- "data/movies.min.Rdata"
  
  if(file.exists(Rdata_file)){
    load(Rdata_file)
  } else {
    data <- read.csv(file = "data/movies.min.csv")
    save(data, file = Rdata_file)
  }
  
  return(data)
}

get_movie_reviews <- function(n = 1000){
  file <- "data/movies.txt"
  con <- file(description = file, encoding = "latin1", open="r")
  
  ## Hopefully you know the number of lines from some other source or
  com <- paste("wc -l ", file, " | awk '{ print $1 }'", sep="")
  n <- system(command=com, intern=TRUE)
  n <- as.numeric(n)
  
  #n <- 9 * 100000
  #vec <- rep(character(0), times = (n / 9) * 5)
  #index <- 1
  
  last_time <- Sys.time()
  records <- (n / 9)
  vec <- lapply(1:records, function(i) {
    tmp <- scan(file=con, nlines=9, quiet=TRUE, what = character(), sep = "\n")
    
    if(i %% 1000 == 0){
      elapsed <- Sys.time() - last_time
      msg_per_sec <- 1000/as.numeric(elapsed, units = "secs")
      eta_minutes <- (records - i) / msg_per_sec / 60
      last_time <<- Sys.time()
      print(paste(i, "out of", records, "Running at", round(msg_per_sec, digits = 1), "per second, eta = ", round(eta_minutes, digits = 1), "minutes"))
    }
    
    return(tmp[c(1,2,4,5,6)])
  })
  
  vec <- unlist(vec)
  close(con)
  
  save(vec, file = "vec.Rdata")
  load("vec.Rdata")
  vec <- str_match(data$text, '(.*):\\s+(.*)')
  save(vec, file = "vec_split.Rdata")
  
  data <- data.frame(vec[,2:3])
  
  data <- data %>%
    mutate(text = as.character(text)) %>%
    filter(nchar(text) > 0) %>%
    extract(text, into=c('key', 'value'), '(.*):\\s+(.*)+')
  
  save(data, file = "data1.Rdata")
  
  index <- 0
  data$id <- sapply(data$key, function(key){
    if(key == "product/productId"){
      index <<- index + 1
    }
    return(index)
  })
  
  save(data, file = "data2.Rdata")
  
  data <- data %>%
    spread(key, value)
  save(data, file = "final_data.Rdata")    
  
  return(data)
}