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
library(tidyverse)# Remember this includes ggplot within this package
library(here)
library(praise)
library(patchwork)

praise()

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

###### Making a Simple Plot #####
ggplot(data=penguins,
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     group = species,
                     color = species)) +
  geom_point()+
  geom_smooth(method = "lm")+ # add a best fit line, look up all different methods 
  labs(x = "Bill depth (mm)",
       y = "Bill length (mm)")+
  #scale_colour_viridis_d()+ # default color blind friendly color 
  scale_color_manual(values = c("orange", "purple", "green"))+
  scale_x_continuous(breaks = c(14, 17, 21))+
                     #labels = c("low", "medium", "high")
  theme_classic()

praise() # Dr. Silbiger, you are SO cool for this!!! Omg, thank you for showing me this. 

###### Plotting Notes #####
# Size vs linewidth: size, still works for point based geoms (geom_point (), geom_jitter() - only line thickness moved to linewidth.

# add a best fit line: making it a linear model. Code: geom_smooth(method = "lm")

# If we want to change the scale of a continuous color it would be: scale_color_continuous()

# If we want to change the scale of a continuous x-axis it would b: scale_x_continuous()

# If want the x axis to go from 0 to 20:   scale_x_continuous(limits = c(0,20))+

# There is a plot called "colorBlindness" that are color blind friendly 

##### Week 3 Homework #####
# Instructions: Come up with the best possible plot with the penguin data that you can in 1 hour.

# Step 1: Look at all the data first.
view(penguins)

# Step 2: Creating a plot on the Flipper Length between sexes 
flipper_plot <- ggplot(data=penguins,
                       mapping= aes(x=sex, 
                                     y=flipper_length_mm,
                                     fill=sex)) + 
  geom_boxplot() + 
    labs(x = "Sex",
         y = "Flipper Length (mm)")+
  theme(legend.position = "none")+ # I removed the legend 
  scale_x_discrete(labels = c("female" = "Female", # I didn't like how it was in lowercase, so I'm changing the labels 
                              "male" = "Male")) + # got this from ggplot cheatsheets github 
  scale_fill_manual(values = c("#8c510a","#5ab4ac", "#01665e"))+# These colors are safe, used colorbrewer - Shoutout to Travis for teaching me 
  theme_classic()+
  theme(legend.position = "none")
  
flipper_plot

# I want to try using patchwork, so I'm doing the same but with body mass 

# Step 3: Create the same boxplot but Body Mass instead 
mass_plot <- ggplot(data=penguins,
                       mapping= aes(x=sex, 
                                    y=body_mass_g,
                                    fill=sex)) + 
  geom_boxplot() + 
  labs(x = "Sex",
       y = "Body Mass (g)")+
  scale_x_discrete(labels = c("female" = "Female", # I didn't like how it was in lowercase, so I'm changing the labels 
                              "male" = "Male")) + # got this from ggplot cheatsheets github 
  scale_fill_manual(values = c("#8c510a","#5ab4ac", "#01665e"))+# These colors are safe, Used colorbrewer - Shoutout to Travis for teaching me 
  theme_classic()

mass_plot

# Step 4: Create Patchwork 
penguin_patchwork <- flipper_plot / mass_plot # The "/" makes one plot on top of another 
penguin_patchwork # For my final plot, I removed the legend from the Flipper Length Plot becuase I thought two legends were going to be two much 

# Step 5: Saving Figure as Image 
ggsave(here("Week_03","penguin_CarolinaMD.png"),
            width = 7,
            height = 8) # in inches
