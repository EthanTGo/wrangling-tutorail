library(dslabs)

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
