###### Homework Week 4 Part 2 #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/22/2026 
# This script 

###### Load Libraries ######
library(tidyverse)# Remember this includes ggplot within this package
library(here)
library(praise)
library(dplyr)
library(patchwork)

###### Load Data #####
ChemData <- read_csv(here("Week_04", "Data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)
view(ChemData) # opens a new window with all the values 

###### Cleaning Up Data #####
ChemData_clean <- ChemData |>
  drop_na() |> # removes all rows containing an NA
  separate_wider_delim(
    cols = Tide_time,
    delim = "_",
    names = c("Tide", "Time"),
    cols_remove = FALSE) |>
  mutate(Site_Zone = paste(Site, Zone, sep = ".")) # combines Site and Zone into one column


###### Filtering a Subset #####
ChemData_LowTide <- ChemData_clean |>
  filter(Tide == "Low")

view(ChemData_LowTide)

###### Using Pivot_longer() and Summary Stats #####
ChemData_LowTide_Long <- ChemData_LowTide |>
  pivot_longer(
    cols = Temp_in:percent_sgd, # select columns to pivot
    names_to = "Variables",     # new column for old column names
    values_to = "Values"        # new column for the values
  )

view(ChemData_LowTide_Long)

praise()

## Summary Stats 
ChemData_LowTide_Long_Stats <- ChemData_LowTide_Long |>
  group_by(Variables, Site_Zone) |>
  summarise(
    mean_value = mean(Values, na.rm = TRUE),
    standard_deviation = sd(Values, na.rm = TRUE),
    variance_value = var(Values, na.rm = TRUE)) |>
  write_csv(here("Week_04", "Outputs", "summary_homework_part2.csv")) # Exporting the stats 

view(ChemData_LowTide_Long_Stats)

praise()

###### Plotting ##### 
# Trying a jitter plot to plot everything 

# Okay so I want to try something different... I want to put the sites on the y axis and the seawater parameters values on the x. 

ChemData_LowTide_Plot <- ggplot(
  data = ChemData_LowTide_Long,
  mapping = aes(
    x = Values,
    y = Site_Zone,
   color = Site_Zone)) + # For jitterplots, use color instead of fill 
  geom_jitter(
    height = 0.12, # this helps with overlapping values
    width = 0,
    size = 1.5, # size of each point 
    alpha = 0.7) + # alpha makes points transparent 
  facet_wrap(
    ~Variables,
    scales = "free_x") +
  labs(
    x = "Measured Values",
    y = "Site and Zone",
    color = "Site and Zone") +
  scale_color_manual( # got my colors from colorbrewer! 
    values = c(
      "#67001f","#b2182b", "#d6604d","#f4a582", "#4393c3","#2166ac","#053061"))+
  theme_classic() 

ChemData_LowTide_Plot

# Saving Plot 
ggsave(filename = here("Week_04", "Outputs",
                       "HomeworkWeek4_Part2_CarolinaMD.png"),
       plot = ChemData_LowTide_Plot,
       width = 6,
       height = 5)
