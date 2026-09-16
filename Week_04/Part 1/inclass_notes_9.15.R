###### Intro to Plotting Script #######
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
library(dadjokeapi)

###### Load Data #####
# This data is part of the package and is called penguins. We are practicing 
glimpse(penguins)
view (penguins) # opens in a new tab and shows you all the data 
head (penguins) 

##### Filtering #####

penguins_female <- filter(.data= penguins, sex == "female")
# We can use "filter" to extract rows that meet some criteria 

### Example:
# 1. Penguins measured in the year 2008? 
# 2. Penguins that have a body mass greater than 5000? 

penguins_2008 <- filter(.data= penguins, year == "2008")
penguins_5000 <- filter(.data= penguins, body_mass_g > "5000")

### Filtering with multiple conditions 
# Example: Select females that are also greater than 5000 g
penguins_female_5000 <- filter(.data = penguins, sex == "female", body_mass_g > 5000)

### Boolean Logic 
# Practice: Use filter and boolean logic to show:
# 1. Penguins that were collected in either 2008 or 2009
# 2. Penguins that are not from the island Dream
# 3. Penguins in the species Adelie and Gentoo

pen_or <- filter(.data= penguins,
                 year == "2008" | year == "2009")
            
pen_dream <- filter(.data= penguins, 
                    island != "Dream")

pen_ad_gen <- filter(.data= penguins, 
                     species == "Adelie" | species =="Gentoo")

# Another option: filter(.data = penguins,island %in% c("Adelie", "Gentoo"))

##### Mutating #####
# This basically means adding new columns 

## Example: Add a new column converting body mass in g to kg

penguins_kg <- mutate(.data = penguins,
                      body_mass_kg = body_mass_g / 1000)

## Example: Think, pair, share
# 1. Use mutate to create a new column to add flipper length and body mass together
# 2. Use mutate and if_else to create a new column where body mass greater than 4000 is labeled as “big” and everything else is “small”

example_1 <- mutate(.data = penguins,
                    sum  = body_mass_g + flipper_length_mm,
                    chonk = if_else(body_mass_g > 4000, "big", "small"))

##### The Pipe #####
# The “pipe” says “and then do”

## Example 
# Filter only female penguins and add a new column that calculates the log body mass.

penguins |>
  filter(sex == "female") |>
  mutate(log_mass = log(body_mass_g))

##### Select ####
#You can also use select() to rename columns.

penguins |>
  filter(sex == "female") |>
  mutate(log_mass = log(body_mass_g)) |>
  select(Species = species, island, sex, log_mass)

##### Other Functions #####
## Summarize: Compute a table of summarized data 
# Calculate the mean and min flipper length
penguins |>
  summarise(mean_flipper = mean(flipper_length_mm, na.rm = TRUE),
            min_flipper  = min(flipper_length_mm, na.rm = TRUE))


## Removing NAs: Drop all the rows that are missing data on sex 
penguins |>
  drop_na(sex)

praise()
groan() # Was NOT expecting the noise lol 
