###### Intro to Data Wrangling Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/22/2026 
# This script is to learn how Data Wrangling: joins & dates with lubridate 

###### Load Libraries ######
library(tidyverse) 
library(here)
library(praise)
library(dplyr)
library(patchwork)

###### Load Data ##### 
CondData <- read_csv(here("Week_05", "Data", "CondData.csv"))


###### Creating Small Tibbles #####
T1 <- tibble(
  Site.ID = c("A", "B", "C", "D"),
  Temperature = c(14.1, 16.7, 15.3, 12.8)
)

T1

T2 <- tibble(
  Site.ID = c("A", "B", "D", "E"),
  pH = c(7.3, 7.8, 8.1, 7.9)
)

T2

## Left join keeps all rows from the left (first) dataframe and adds matching rows from the right

left_join(T1, T2)

## Right join keeps all rows from the right (second) dataframe

right_join(T1, T2)

## Inner Join keeps only rows that exsit in both dataframes 

inner_join(T1, T2)

## Full Join keeps all rows from both dataframes

full_join(T1, T2)

## Anti join: super helpful for finding missing data 

anti_join(T1, T2)

##### Dates & Times with Lubridate #####
### Lubridate is already in the tidyverse package 

now() # Que cool! 
now (tzone = 'EST') #Puerto Rico, I miss you 

today()
today (tzone = 'EST')

### Convert dates:ISO format (YYYY-MM-DD)
ymd("2021-02-24")

### Create a vector of dateframes 
datetimes <- c(
  "02/24/2021 22:22:20",
  "02/25/2021 11:21:10",
  "02/26/2021 8:01:52"
)

datetimes

### Convert the vector to datatime objects 
datetimes <- mdy_hms(datetimes)

datetimes

## Example 

datetime_naive <- mdy_hms("02/24/2021 10:22:20")
datetime_naive

# with_tz() - View same moment in different timezone 

hawaii_time <- with_tz(datetime_naive, tzone = "US/Hawaii")
hawaii_time

##### Practicing #####
## Read in the conductivity data (CondData.csv) and convert the date column to a datetime using the pipe:


  








