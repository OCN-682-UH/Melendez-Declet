###### Intro to Data Wrangling Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/15/2026 
# This script is to learn how Data Wrangling: tidyr 

###### Load Libraries ######
library(tidyverse)# Remember this includes ggplot within this package
library(here)
library(praise)
library(dplyr)
library(patchwork)

###### Load Data #####
ChemData <- read_csv(here("Week_04", "Data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)
view(ChemData)

###### Cleaning Up #####

ChemData_clean <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |>
  mutate(Site_Zone = paste(Site, Zone, sep = "."))

view(ChemData_clean)

####### Pivot Longer ######
ChemData_long <- ChemData_clean |>
  pivot_longer(cols      = Temp_in:percent_sgd, # select columns to pivot
               names_to  = "Variables",         # new column for old column names
               values_to = "Values")            # new column for the values

ChemData_long |>
  group_by(Variables, Site) |>
  summarise(Param_means = mean(Values, na.rm = TRUE),
            

            Param_vars  = var(Values,  na.rm = TRUE))

ChemData_long |>
  ggplot(aes(x = Site, y = Values)) +
  geom_boxplot() +
  facet_wrap(~Variables, scales = "free")

###### Pivot Wide #####
ChemData_wide <- ChemData_long |>
  pivot_wider(names_from  = Variables,
              values_from = Values)

###### Full Pipeline #####
ChemData_clean <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols        = Tide_time,
                       delim       = "_",
                       names       = c("Tide", "Time"),
                       cols_remove = FALSE) |>
  pivot_longer(cols      = Temp_in:percent_sgd,
               names_to  = "Variables",
               values_to = "Values") |>
  group_by(Variables, Site, Time) |>
  summarise(mean_vals = mean(Values, na.rm = TRUE)) |>
  pivot_wider(names_from  = Variables,
              values_from = mean_vals) |>
  write_csv(here("Week_04", "Outputs", "summary_inclass.csv"))
