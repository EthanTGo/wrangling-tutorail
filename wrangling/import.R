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
dat4 <- read_csv(url,col_names=F)

url <- "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_annmean_mlo.txt"
read_lines(url, n_max =56)
dat5 <- read_table(url, skip=56)



# original wide data
library(tidyverse) 
path <- system.file("extdata", package="dslabs")
filename <- file.path(path,  "fertility-two-countries-example.csv")
wide_data <- read_csv(filename)
# tidy data from dslabs
library(dslabs)
data("gapminder")
tidy_data <- gapminder %>% 
  filter(country %in% c("South Korea", "Germany")) %>%
  select(country, year, fertility)



#After import we have to reshape data using tidyr package (included in tidyverse)
#gather() converts wide data into tidy data
#gather(first_arg, second_arg, third_rg)
#third arg specifies the columns that will be gathered, bydefault it is all the columns
#first args sets the name of the columns that  will hold the variable that are kept in the  wide data columns names
#the second argumnets set the name for the column that will hold the values in the column cells
new_tidy_data <- wide_data %>% gather(year, fertility, '1960':'2015')
#here is another implementation, -country means gather all columns EXCEPT COUNTRY
new_tidy_data <- wide_data %>% gather(year, fertility, -country)
new_tidy_data$year # we see that gather assumes everything to be of type character
new_tidy_data <- wide_data %>% gather(year, fertility, -country, convert= T) #convert fixes this

new_tidy_data %>%
  ggplot(aes(year, fertility, color = country)) +
  geom_point()

#spread function is the inverse of gather, it converts tidy into wide data
# spread tidy data to generate wide data, first argument tells which variables to use as columns and second argumnet tells which data to fill those columns
new_wide_data <- new_tidy_data %>% spread(year, fertility)
select(new_wide_data, country, `1960`:`1967`)


#separate and unite
# import data
path <- system.file("extdata", package = "dslabs")
filename <- file.path(path, "life-expectancy-and-fertility-two-countries-example.csv")
raw_dat <- read_csv(filename)
select(raw_dat, 1:5)

# gather all columns except country
dat <- raw_dat %>% gather(key, value, -country)
head(dat)
dat$key[1:5]

#separate takes three argument, apart from the data
#1. name of the columns to be separated
#2. names to be used for the new columns
#3. characters that separates the variables
#unite is the inverse of separate in that it unites two columns into one
# split on all underscores, pad empty cells with NA
dat %>% separate(key, c("year", "first_variable_name", "second_variable_name"), 
                 fill = "right")
# split on first underscore but keep life_expectancy merged
dat %>% separate(key, c("year", "variable_name"), sep = "_", extra = "merge")
# separate then spread
dat %>% separate(key, c("year", "variable_name"), sep = "_", extra = "merge") %>%
  spread(variable_name, value) 
# separate then unite
dat %>% 
  separate(key, c("year", "first_variable_name", "second_variable_name"), fill = "right") %>%
  unite(variable_name, first_variable_name, second_variable_name, sep="_")
# full code for tidying data
dat %>% 
  separate(key, c("year", "first_variable_name", "second_variable_name"), fill = "right") %>%
  unite(variable_name, first_variable_name, second_variable_name, sep="_") %>%
  spread(variable_name, value) %>%
  rename(fertility = fertility_NA)

co2_wide <- data.frame(matrix(co2, ncol = 12, byrow = TRUE)) %>% 
  setNames(1:12) %>%
  mutate(year = as.character(1959:1997))
co2_tidy <- gather(co2_wide, month, co2, -year)

co2_tidy %>% ggplot(aes(as.numeric(month), co2, color = year)) + geom_line()


library(dslabs)
data(admissions)
dat <- admissions %>% select(-applicants)

tmp <- gather(admissions, key, value, admitted:applicants)
tmp

tmp2 <- unite(tmp, column_name, c(key,gender))

spread(tmp2, column_name, value)
