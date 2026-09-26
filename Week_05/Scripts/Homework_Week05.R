###### Advanced Plotting Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/25/2026 
# This script is my homework assignment for Week 05 

###### Load Libraries #####
library(tidyverse) 
library(here)
library(dplyr)
library(patchwork)

###### Load Data ######
CondData <- read_csv(here("Week_05", "Data", "CondData.csv"))
DepthData <-read_csv(here("Week_05", "Data", "DepthData.csv"))

###### Convert Date Columns #####
# For my conductivity data, I need to round the data to the nearest 10 secs to match depth data 
CondData <- CondData |> 
  mutate(date = mdy_hms(date)) |> 
  mutate(date = round_date(date, "10 seconds"))

DepthData <- DepthData |> 
  mutate(date = ymd_hms(date))

###### Combine Data & Conduct Summary Stats ######

FinalData <- CondData |> 
  inner_join(DepthData, by = "date") |> # Exact matches 
  mutate(date_min = round_date(date, "minute")) |> #Round to minute 
  group_by(date_min) |> 
  summarise(mean_depth= mean(Depth, na.rm = TRUE),
            mean_temp = mean(Temperature, na.rm = TRUE),
            mean_salinity = mean(Salinity, na.rm = TRUE)) |> 
  write_csv(here("Week_05", "Outputs", "summary_stats_homework.csv"))

  
###### Graphing Data ######
  
