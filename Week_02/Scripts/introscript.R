###### Intro to R Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/02/2026 
# This script is to learn how to import data. 

###### Load Libraries ######
library(tidyverse)
library(here)
# Remember to download/install packages in your console and not in the live script 

###### Upload Data ######
WeightData <- read_csv(here("Week_02", "Data", "weightdata.csv"))

###### Data Analysis #####
head(WeightData) # This will show you the top 6 lines of the data 
tail(WeightData) # Will show the bottom 6 lines 
view (WeightData) # Shows you the full data, I also like to click on the data in the environment as well 

####### HW 2 - Week_02 ######
# Task 1: Push the week 2 folder with this script and associated data into my personal github repository 

#Step 1: Go to your terminal 
