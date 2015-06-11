# CSC-495
Social Network Analysis Class Project CSC 495

Data is available from the [Stanford website](https://snap.stanford.edu/data/web-Movies.html)

Please reference this cheat sheet for info on some of the [Data Wrangling](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

# Java
Java folder contains a maven project that has two main methods, they both prune the data to remove textual review data and names in order to reduce file size. One method retains original file format the other converts each record into a CSV.

Java 1.8+ and Maven are needed in order to build source code. Just run "mvn clean install" to compile or run code from your favorite IDE.

# R
The R code (main function in do.R) will consume the output of the Java parsed data from Stanford. Then it will filter the data and produce bipartite projections of the movies related to other movies via shared reviewers.

Once the do.R main function is done, you can run the .Rmd to produce the appendix of the report.