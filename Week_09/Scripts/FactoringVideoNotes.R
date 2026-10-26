###### Intro to Factoring Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 10/23/2026
# This script is to learn how to do factoring in R 

###### Load Libraries ######
library(tidyverse)
library(tidytuesdayR)
library(here)

###### Load Data ######
# Option 1: via tidytuesdayR
income_mean <- tidytuesdayR::tt_load(2021, week = 7)$income_mean

##### What is a Factor? #####
# A factor is a specialized version of a character - it is how R truly stores categorical data

# Levels let you control the order of categories in plots and summaries

### Reading In Data Safely 
# Always use read_csv(). You then convert to factors intentionally and explicitly, only when you need a specific ordering - not by accident on import.

##### The {foracts} Package #####

glimpse(starwars)

## How many of Each Species?
starwars |>
  filter(!is.na(species)) |>   # remove NAs
  count(species, sort = TRUE)

## Lump Rare Levels Togethers 
# fct_lump(x, n) keeps the n most common levels and collapses everything else into "Other"

star_counts <- starwars |>
  filter(!is.na(species)) |>
  mutate(species = fct_lump(species, n = 3)) |>
  count(species)

star_counts

###### Reordering Factors #####
star_counts |>
  ggplot(aes(x = species, y = n)) +
  geom_col()

## fct_reorder() — Sort by Another Variable

star_counts |>
  ggplot(aes(x = fct_reorder(species, n), y = n)) +
  geom_col()

## We can do it by descending order 
star_counts |>
  ggplot(aes(x = fct_reorder(species, n, .desc = TRUE), y = n)) +
  geom_col() +
  labs(x = "Species")


###### Reordering Line Plot Legends #####
glimpse(income_mean)


## Summarize by Year and Quintile 
total_income <- income_mean |>
  group_by(year, income_quintile) |>
  summarise(income_dollars_sum = sum(income_dollars), .groups = "drop") |>
  mutate(income_quintile = factor(income_quintile))

## Basic Line Plot - Legend in Wrong Order 
total_income |>
  ggplot(aes(x = year, y = income_dollars_sum,
             color = income_quintile)) +
  geom_line()

# The legend order doesn’t match the line order — the highest income group is at the bottom of the legend.

## fct_reorder2() — Reorder by Two Variables
total_income |>
  ggplot(aes(x = year, y = income_dollars_sum,
             color = fct_reorder2(income_quintile, year, income_dollars_sum))) +
  geom_line() +
  labs(color = "income quintile")

###### Setting Levels Manually #####
## Use the levels argument inside factor() to set the exact order you want

# Without levels — alphabetical by default
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"))
x1

# With levels — your specified order
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"),
             levels = c("Jan", "Mar", "Apr", "Dec"))
x1


###### Subsetting Factors ######
# What happens to factor levels when you filter your data?

# Filter to Common Species 
starwars_clean <- starwars |>
  filter(!is.na(species)) |>
  count(species, sort = TRUE) |>
  mutate(species = factor(species)) |>   # convert to factor
  filter(n > 3)                          # keep only common species

starwars_clean

# Droplevels() (base R) or fct_drop() (forcats) removes any levels that no longer appear in the data:
starwars_clean <- starwars |>
  filter(!is.na(species)) |>
  count(species, sort = TRUE) |>
  mutate(species = factor(species)) |>
  filter(n > 3) |>
  droplevels() # remove unused levels

levels(starwars_clean$species)

## fct_recode(f, “new name” = “old name”) renames one or more levels:

starwars_clean <- starwars |>
  filter(!is.na(species)) |>
  count(species, sort = TRUE) |>
  mutate(species = factor(species)) |>
  filter(n > 3) |>
  droplevels() |>
  mutate(species = fct_recode(species, "Humanoid" = "Human"))

starwars_clean


