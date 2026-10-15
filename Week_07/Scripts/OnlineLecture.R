###### Intro to Maps Script - Part 2  #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 10/07/2026
# This script is to learn how to create maps in R Studio. 

###### Load Libraries ######
library(tidyverse)
library(here)
library(sf)
library(maptiles)
library(tidyterra)
library(leaflet)
library(tidygeocoder)
library(ggspatial)

###### Load Data ######
ChemData <- read_csv(here("Week_07", "Data", "chemicaldata_maunalua.csv"))

glimpse(ChemData)

view(ChemData)

###### MapTiles ######
## Online maps (Google, OpenStreetMap, ESRI) are not single images — they are made of thousands of small 256 × 256 pixel tiles stitched together.

## This is exactly how Google Maps works 

## Step 1: Define your area of interest 

# Define a bounding box around Wailupe, Oahu
# xmin/xmax = westmost/eastmost longitude
# ymin/ymax = southernmost/northernmost latitude
wailupe_bbox <- st_as_sfc(
  st_bbox(c(xmin = -157.772, ymin = 21.267,
            xmax = -157.752, ymax = 21.281),
          crs = 4326)) # crs = 4326 means WGS84 — the lat/lon system your GPS uses

## Step 2: Download the Tiles 
tiles_satellite <- get_tiles(
  wailupe_bbox,               # the area to download
  provider = "Esri.WorldImagery", # which tile source to use
  zoom = 16,                  # level of detail (3 = continent, 20 = building)
  crop = TRUE,                # clip to our exact bbox (vs. slightly larger)
  cachedir = here("Week_07", "Data", "tiles_cache") # save tiles to disk
)

class(tiles_satellite)
# A SpatRaster — a raster image (grid of pixels) from the {terra} package.

## Step 3: Plot with geom_spatraster_rgb()

# geom_spatraster_rgb() is from {tidyterra}
# It reads the 3 color layers and renders them as a photo
ggplot() +
  geom_spatraster_rgb(data = tiles_satellite) +
  coord_sf(crs = 4326) + 
  theme_minimal()

###### Deriving the Bbox from your data #####
# Step 1: convert your data frame to an sf object
# coords tells sf which columns hold longitude and latitude
ChemData_sf <- st_as_sf(ChemData,
                        coords = c("Long", "Lat"),
                        crs = 4326)

# Step 2: get the bounding box and add a small buffer
# the + c(...) pads all four sides by ~0.4 km so points aren't at the edge
bbox_chem <- st_bbox(ChemData_sf) + c(-0.004, -0.004, 0.004, 0.004)

# Step 3: download tiles for that extent
Map_satellite <- get_tiles(
  st_as_sfc(bbox_chem),
  provider = "Esri.WorldImagery",
  zoom = 15,
  crop = TRUE,
  cachedir = here("Week_07", "data", "tiles_cache")
)




