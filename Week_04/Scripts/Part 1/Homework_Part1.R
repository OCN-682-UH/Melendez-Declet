###### Intro to Data Wrangling Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/25/2026 
# This script is to learn how Data Wrangling: dplyr 

###### Load Libraries ######
library(palmerpenguins)
library(tidyverse)# Remember this includes ggplot within this package
library(here)
library(praise)
library(dplyr)
library(patchwork)


###### Homework Instructions #######
# Write a script that: 
## calculates the mean and variance of body mass by species, island, and sex without any NAs

# AND 

# filters out (i.e. excludes) male penguins, then calculates the log body mass, 
#then selects only the columns for species, island, sex, and log body mass, then use these data to make any plot. 
# Make sure the plot has clean and clear labels and follows best practices. Save the plot in the correct output folder.

###### Load Data #####
# This data is part of the package and is called penguins. We are practicing 
glimpse(penguins)
view (penguins) # opens in a new tab and shows you all the data 
head (penguins) 

###### Number 1 #####
# Part A: Calculating the mean and variance of body mass by species 
penguin_mean_variance_species <- penguins |> # the name of the dataset 
  group_by(species) |> # this tells R to get the results by species 
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE),
            variance_body_mass = var(body_mass_g, na.rm = TRUE))
# I like to give everything an assignment name it makes it easier to find in my environment

# Remember: "na.rm = TRUE" means to ignore the missing values, so we're okay 


# Part B: Calculating the mean and variance of body mass by Island 
penguin_mean_variance_island <- penguins |> # the name of the dataset 
  group_by(island) |> # this tells R to get the results by Island  
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE),
            variance_body_mass = var(body_mass_g, na.rm = TRUE))

# Part C: Calculating the mean and variance of body mass by sex 
penguin_mean_variance_sex <- penguins |> # the name of the dataset 
  drop_na(sex)|> # # Removing NAs: Drop all the rows that are missing data on sex 
  group_by(sex) |> # this tells R to get the results by species 
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE),
            variance_body_mass = var(body_mass_g, na.rm = TRUE))



###### Number 2 #######
# Part 1: filters out (i.e. excludes) male penguins, then calculates the log body mass, then selects only the columns for species, island, sex, and log body mass 

penguins_no_boys <- penguins |>
  filter(sex != "male") |> # excludes male penguins. The "!" means not equal to male 
  mutate(log_body_mass = log(body_mass_g)) |> # calculates log body mass, and adds a new column to the data 
  select(species, island, sex, log_body_mass) # selects only these columns

# Part 2: Make any kind of plot with this data 
bodymassplot_nomales <- ggplot(data = penguins_no_boys,
                             mapping = aes(x = species,
                                           y = log_body_mass,
                                           fill = species)) +
  geom_boxplot() +
  labs(x = "Species",
       y = "Log Body Mass",
       fill = "Species") +
  scale_fill_manual(values = c("#8c510a", "#5ab4ac", "#01665e")) +
  theme_classic()

bodymassplot_nomales


##### Saving Plot ######
ggsave(filename = here("Week_04", "Outputs",
                       "HomeworkWeek4_Part1_CarolinaMD.png"),
       plot = bodymassplot_nomales,
       width = 6,
       height = 5)