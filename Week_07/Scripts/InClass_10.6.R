###### Intro to Maps Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 10/06/2026
# This script is to learn how to create maps in R Studio. 

##### Load Libraries ######
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

##### Load Data #####
# Population in California by county
popdata <- read_csv(here("Week_07", "data", "CApopdata.csv"))

# Seastar counts at field sites in California
stars <- read_csv(here("Week_07", "data", "stars.csv"))

##### Mapdata package #####

# map_data() pulls polygon boundaries for countries, states, and counties — ready to use with ggplot.

world <- map_data("world")

head(world)

italy <- map_data("italy")
head(italy)

states <- map_data("state")

counties <- map_data("county")

##### Making a Map of the World #####

# long - longitude. West of the prime meridian is negative.

# group - This one is critical! Controls whether adjacent points are connected by lines. Points in the same group get connected; different groups cause ggplot to “lift the pen.”

# region/subregion - the region or subregion a set of points surrounds

# order - the order in which ggplot connects the dots (polygon vertices)


## Basic plot 

ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group,
                   fill = region), # fill by region 
               color = "black") +
  guides(fill = "none")+
  theme_minimal() # get rid of grey background


## Make the ocean blue 
ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group,
                   fill = region),
               color = "black") +
  theme_minimal() +
  guides(fill = "none") +
  theme(panel.background =
          element_rect(fill = "lightblue"))

## Change the Map Projection 

# The earth is not flat, but we visualize it in 2D — there are many projections to choose from.
# See {mapproj} for available options.

ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group,
                   fill = region),
               color = "black") +
  theme_minimal() +
  guides(fill = "none") +
  theme(panel.background =
          element_rect(fill = "lightblue")) +
  coord_map(projection = "mercator",
            xlim = c(-180, 180))

# Another option: using sinusoidal projection 

ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group,
                   fill = region),
               color = "black") +
  theme_minimal() +
  guides(fill = "none") +
  theme(panel.background =
          element_rect(fill = "lightblue")) +
  coord_map(projection = "sinusoidal",
            xlim = c(-180, 180))

##### Map of Just California #####

CA_data <- states |> 
  filter(region == "california")

CA_Map <- ggplot() +
  geom_polygon(data = CA_data, 
               aes(x = long, y = lat,
                   group = group),
               color = "green")+ # Ojo - this is the outline of the state 
  theme_minimal()

CA_Map

## theme_void() - makes the lines go away 

##### Wrangling the Data - Counties #####
CApop_county <- popdata |>
  select("subregion" = County, Population) |>   # rename to match counties
  inner_join(counties) |>
  filter(region == "california")  

head(CApop_county)

##### Making a Map of CA by County & Population #####

ggplot() +
  geom_polygon(data = CApop_county,
               aes(x = long, y = lat,
                   group = group,
                   fill = Population),
               color = "black") +
  coord_map() +
  theme_void() # Removes the lines 

## These colors are default that R gives 

### Log scale for Easier Interpretation 
# transform = “log10” compresses the color scale so that less-populated counties are still visible alongside Los Angeles.
ggplot() +
  geom_polygon(data = CApop_county,
               aes(x = long, y = lat,
                   group = group,
                   fill = Population),
               color = "black") +
  coord_map() +
  theme_void() +
  scale_fill_gradient(transform = "log10")

##### Adding Layers to Maps #####
# The stars dataset has seastar counts (per m²) at field sites in California.
head(stars)
view(stars)

## Overlay Seastar Sites 
ggplot() +
  geom_polygon(data = CApop_county,
               aes(x = long, y = lat,
                   group = group,
                   fill = Population),
               color = "black") +
  geom_point(data = stars,
             aes(x = long, y = lat,
                 size = star_no)) +
  coord_map() +
  theme_void() +
  scale_fill_gradient(transform = "log10") +
  labs(size = "# stars/m²")

ggsave(here("Week_07", "Outputs", "CA_Pop_Plot.pdf"))



##### The Modern Approach: {sf} + {rnaturalearth} #####
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf")

ggplot(world_sf) +
  geom_sf(fill = "lightgray",
          color = "white") +
  theme_void()

## coord_sf() handles projections using standard EPSG codes — much more rigorous than {mapproj}:

ggplot(world_sf) +
  geom_sf(fill = "lightgray", color = "white") +
  coord_sf(crs = "+proj=robin") + # Robinson projection
  theme_void() +
  labs(title = "Robinson Projection")


