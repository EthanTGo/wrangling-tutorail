library(dslabs)
library(tidyverse)

#the system.file loeads data automatically from the dslabs package
path <- system.file("extdata", package="dslabs")
list.files(path)

#using r to import data
filename <- "murders.csv"
fullpath <- file.path(path, filename)
fullpath

#copies to working directory
file.copy(fullpath, getwd())

#checks whether the  file is in our wd
file.exist(filename)


#look at the file
read_lines(filename, n_max =3 )


dat <- read_csv(filename)

#read.csv is different than read_csv in that it makes the object in a data.frame object but read_csv makes it on a tibble data type
dat2 <- read.csv(filename)
class(dat2)

#because strings columns are turned into factors we need to correct this
dat3 <- read.csv(filename, stringsAsFactors = FALSE)


#downloading file from the internet
url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"
dat <- read_csv(url)
#loval file
download.file(url, "murders.csv")


#creastes directory
tempfile()
tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename)


url <- "http://mlr.cs.umass.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"
dat4 <- read_csv(url,colnames=F)

