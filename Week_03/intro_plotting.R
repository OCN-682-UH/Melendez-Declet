###### Intro to Plotting Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/08/2026 
# This script is to learn how to use ggplot and practice creating plots. Includes script from Part 1 and Part 2.

###### Personal Notes ######
# Adding script to Git Hub 

# Watch the video on youtube (Sorry, I forget easily): GitHub Quick Tutorial for R and RStudio Projects Data Science

###### Load Libraries ######
library(palmerpenguins)
library(tidyverse) # Remember this includes ggplot within this package

###### Practice Plotting #####
ggplot(data=penguins,
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     color = species,
                     size = body_mass_g,
                     alpha = flipper_length_mm)) + # adding a plus is a adding a layer to your plot 
  geom_point(size = 2, alpha = 0.5)+
  labs(title= "Bill depth and length",
       subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins", # another legend below your legend 
       x = "Bill Depth (mm)", y = "Bill Length (mm)", 
       color = "Species", 
       caption = "Source: Palmer Station LTER / palmerpengiuns package")+
  scale_colour_viridis_d() # changes your color scales and makes it color blind friendly 






###### Facting #####
# Facet grid 
ggplot(penguins, 
       aes(x = bill_depth_mm,
           y = bill_length_mm,
           color = species))+
  geom_point()+
  scale_colour_viridis_d()+
  facet_grid(species~sex)+
  guides(color = "none")
# makes multiple plot groups by species 


# Facet wrap 
ggplot(penguins, 
       aes(x = bill_depth_mm,
           y = bill_length_mm))+
  geom_point()+
  facet_wrap(~ species, ncol=2) # how many columns you want 






