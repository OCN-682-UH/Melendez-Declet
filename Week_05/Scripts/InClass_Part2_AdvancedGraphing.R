###### Advanced Plotting Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/25/2026 
# This script is to learn advanced plotting techniques for creating publication-ready visualizations


###### Load Libraries ######
library(tidyverse) 
library(palmerpenguins)
library(here)
library(patchwork)
library(ggrepel)
library(gganimate)
library(gifski)
library(plotly)
library(magick)

###### Patchwork #######
### Patchwork makes it easy to bring your plots together with simple operations 

p1 <- penguins |>
  ggplot(aes(x= body_mass_g,
             y= bill_length_mm,
             color=species))+
  geom_point()

p1 # First Plot


p2 <- penguins |>
  ggplot(aes(x= sex,
             y= body_mass_g,
             color=species))+
  geom_jitter(width=0.2)

p2 # Second plot 

### Combine plots with +

p1 + p2 +
  plot_layout(guides ='collect') + # Have one legned 
  plot_annotation(tag_levels = 'A') # Add labels (A, B, etc.)

### Stack plots vertically 
p1 / p2 +
  plot_layout(guides ='collect') + # Have one legned 
  plot_annotation(tag_levels = 'A') # Add labels (A, B, etc.)



###### GGrepel #######
### Makes it easy to add clear, non overlapping labels to your plots 

head(mtcars) # Comes with ggplot 
view(mtcars)

## Plot without label repelling 
ggplot(mtcars, aes(x = wt, 
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_text() +
  geom_point(color = 'red')


## Repel the labels with geom_text_repel()
ggplot(mtcars, aes(x = wt, 
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = 'red') # Much clearer!

## Use geom_label_repel() for boxes 
ggplot(mtcars, aes(x = wt, 
                  y = mpg, 
                  label = rownames(mtcars))) +
  geom_label_repel() + # Add boxes around labels for better readability 
  geom_point(color = 'red') 


###### GGAnimate #######
## Lets you create animations that show data changing over time or groups 

penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point()

## Add transition with transition_states()
p <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year,
    transition_length = 2, # give it two secs to 
    state_length = 1) + # how long it stays in that transiton
  labs(title = 'Year: {closest_state}')
anim_save(here("Week_05", "Outputs", "penguin_animation.gif"), animation = p)

##### Plotly #####
## Creates interactive plots with built-in animation that respond to user input

# Scatterplot 
penguins |> 
  plot_ly(x = ~body_mass_g,
          y = ~bill_depth_mm,
          color = ~species,
          type = "scatter", # what type of plot 
          mode = "markers") |> # how you want to interact with the plot 
  layout(title = "Penguin Body Mass vs Bill Depth",
         xaxis = list(title = "Body Mass (g)"), 
         yaxis = list(title = "Bill Depth (mm)"))

## Plotly plots are interactive! Hover over points to see exact values, zoom in/out, and pan around. 

## Animate by species with frame 
penguins |> 
  plot_ly(x = ~body_mass_g,
          y = ~bill_depth_mm,
          frame = ~species, 
          color = ~species,
          type = "scatter", # what type of plot 
          mode = "markers",
          marker = list(size = 8)) |> # how you want to interact with the plot 
  layout(title = "Penguin Ch",
         xaxis = list(title = "Body Mass (g)"), 
         yaxis = list(title = "Bill Depth (mm)"))

## Advantages of plotly over gganimate 
# - Interactive; hover, zoom, pan
# - Easier syntax: less code than gganimate
# - Web ready: works in HTML, shiny, dashboards
# - 3D capable: can create 3D scatter plots and surfaces 

###### Magick ######
## Lets you read, process, and composite images programmatically 

## Read an image with image_read()

penguin <- image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")

penguin

# We can put this on our plots for example: we can put a coral species on a plot 

penguinplot <-penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() 
ggsave(here("Week_05", "Outputs", "penguinplot.png"))

penguinplot

## Composite images with image_composite()

penplot <- image_read(here("Week_05", "Outputs", "penguinplot.png"))
out <- image_composite(image = penplot,       composite_image = penguin, offset = "+70+30")
out

## Animate composite images: we can combine GIFs with images too
pengif <- image_read("https://media3.giphy.com/media/H4uE6w9G1uK4M/giphy.gif")
outgif <- image_composite(penplot, pengif, gravity = "center")
animation <- image_animate(outgif, fps = 10, optimize = TRUE)
animation

