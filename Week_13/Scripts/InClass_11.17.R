###### Iterative Coding Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 11/17/2026
# This script is for my in-person class by Dr. Nyssa Silbiger on iterative coding. 

###### Load Libraries ######
library(tidyverse)
library(here)

###### for loops #######
## for loops have two major parts: an indexing statemnet and a command (or set of commands) to repeat.The coding is in base R. 

print(paste("The year is", 2000))

# Put it in a loop 
years <- c(2015:2021)

for (i in years) { # i is the index
  print(paste("The year is", i)) # loop over i
}

## We need to pre-allocate space and tell R where it is going to be saved 

# Pre-allocate space: empty columns as long as the years vector
year_data <- tibble(year = rep(NA, length(years)),
                    year_name = rep(NA, length(years)))

year_data

## Simple for loop 

for (i in seq_along(years)) {
  year_data$year_name[i] <- paste("The year is", years[i])
  year_data$year[i] <- years[i]
}

year_data

###### Using loops to read in multiple .csv files ######
testdata <- read_csv(here("Week_13", "data", "cond_data", "011521_CT316_1pcal.csv"))

glimpse(testdata)

# Point to the folder on the computer
CondPath <- here("Week_13", "data", "cond_data")

# List all files in that path matching a pattern (here, anything with .csv)
# You can use regex to be more specific about filenames
files <- dir(path = CondPath, pattern = ".csv")

files

# One row for each file and 3 columns
cond_data <- tibble(filename = rep(NA, length(files)),
                    mean_temp = rep(NA, length(files)),
                    mean_sal = rep(NA, length(files)))

cond_data

# Test by reading in the first file
raw_data <- read_csv(paste0(CondPath, "/", files[1]))
head(raw_data)

mean_temp <- mean(raw_data$Temperature, na.rm = TRUE)
mean_temp

# Now, we put it into a loop
for (i in seq_along(files)) {
  
  raw_data <- read_csv(paste0(CondPath, "/", files[i]))
  
  cond_data$filename[i] <- files[i]
  cond_data$mean_temp[i] <- mean(raw_data$Temperature, na.rm = TRUE)
  cond_data$mean_sal[i] <- mean(raw_data$Salinity, na.rm = TRUE)
}

cond_data

###### purrr ######
# We can do the exact same thing, but with the the tidyverse style language 

# Create a vector from 1:10 
1:10 # a vector from 1 to 10 (we are going to do this 10 times)

# Simple Example 
set.seed(3817)
1:10 |>
  map(rnorm, n = 15) |>
  map_dbl(mean) # the result is now a vector of type "double"

## Bring in files using purrr instead of a for loop 
CondPath <- here("Week_13", "Data", "cond_data")
files <- dir(path = CondPath, pattern = ".csv", full.names = TRUE)

files

## Read in the files 
data <- files |>
  set_names() |>
  map(read_csv) |>
  list_rbind(names_to = "filename") |>
  group_by(filename) |>
  summarise(mean_temp = mean(Temperature, na.rm = TRUE),
            mean_sal = mean(Salinity, na.rm = TRUE))

data


## Other uses: a plot for every file (purrr)
file_names <- dir(path = CondPath, pattern = ".csv") # just the file names

save_temp_plot <- function(file_name) {
  site_name <- str_remove(file_name, "\\.csv")
  
  p <- read_csv(paste0(CondPath, "/", file_name)) |>
    ggplot(aes(x = date, y = Temperature)) +
    geom_line() +
    labs(title = site_name, x = "Date", y = "Temperature (°C)")
  
  ggsave(here("Week_13", "Outputs", paste0(site_name, "_temp.png")),
         plot = p, width = 6, height = 4)
}

walk(file_names, save_temp_plot)

## 
file_names <- dir(path = CondPath, pattern = ".csv") # just the file names

for (i in seq_along(file_names)) {
  
  raw_data <- read_csv(paste0(CondPath, "/", file_names[i]))
  
  site_name <- str_remove(file_names[i], "\\.csv") # drop ".csv" for the title
  
  p <- ggplot(raw_data, aes(x = date, y = Temperature)) +
    geom_line() +
    labs(title = site_name, x = "Date", y = "Temperature (°C)")
  
  ggsave(here("Week_13", "output", paste0(site_name, "_temp.png")),
         plot = p, width = 6, height = 4)
}

## Other uses: a plot for every file (for loop)
file_names <- dir(path = CondPath, pattern = ".csv") # just the file names

for (i in seq_along(file_names)) {
  
  raw_data <- read_csv(paste0(CondPath, "/", file_names[i]))
  
  site_name <- str_remove(file_names[i], "\\.csv") # drop ".csv" for the title
  
  p <- ggplot(raw_data, aes(x = date, y = Temperature)) +
    geom_line() +
    labs(title = site_name, x = "Date", y = "Temperature (°C)")
  
  ggsave(here("Week_13", "Outputs", paste0(site_name, "_temp.png")),
         plot = p, width = 6, height = 4)
}
