###### Intro to Functional Programming Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 10/13/2026
# This script is to learn how to do functional programming - writing reusable code 

##### Load Libraries ######
library(tidyverse)
library(here)
library(palmerpenguins)
library(praise)
library(PNWColors)

##### Example: Rescaling Data ######
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

head(df)

## Without a function: Manual rescaling 
df <- df |>
  mutate(a = (a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)))

head(df)

## Copy and paste for each column 
df <- df |>
  mutate(
    a = (a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
    b = (b - min(b, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(b, na.rm = TRUE)),
    c = (c - min(c, na.rm = TRUE)) / (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),
    d = (d - min(d, na.rm = TRUE)) / (max(d, na.rm = TRUE) - min(d, na.rm = TRUE))
  )

## Did you see the mistake?? Super easy to make mistakes in R 

##### Writing a Function #####
## Create a reusable rescaling function 
rescale01 <- function(x) {
  value <- (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
  return(value)
}

df |>
  mutate(
    a = rescale01(a),
    b = rescale01(b),
    c = rescale01(c),
    d = rescale01(d)
  )

## Even better: use "mutate(across(everything()))
df |>
  mutate(across(everything(), rescale01))

##### Unit Conversions Function #####

## Step 1: The Conversion Formula 
#temp_C <- (temp_F -32) * 5 / 9



## Step 2: Create the Function Structure 
f_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9 # code goes here
  return(temp_C)
}

## Testing 

f_to_celsius(32)

f_to_celsius(212)

###### Practicing Writing Functions #####

## Write a function that converts Celsius to Kelvin 
#temp_K <- (temp_C + 273.15)

c_to_kelvin <- function(temp_C) {
  temp_K <- (temp_C + 273.15) # code goes here
  return(temp_K)
}

c_to_kelvin(42)

c_to_kelvin(5)

praise()


###### Making Plot Functions #####
## SO good for time series!! 

pal <- pnw_palette("Lake", 3, type = "discrete")


ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_manual("Island", values = pal) +
  theme_bw()

## Add flexible arguments 
myplot <- function(data = penguins, x, y) {
  pal <- pnw_palette("Lake", 3, type = "discrete")
  
  ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
    geom_point() +
    geom_smooth(method = "lm") +
    scale_color_manual("Island", values = pal) +
    theme_bw()
}

## Test it 
myplot(x = body_mass_g, y = bill_length_mm)

myplot(x = body_mass_g, y = flipper_length_mm)

## Layer onto the function 
myplot(x = body_mass_g, y = flipper_length_mm) +
  labs(x = "Body mass (g)", y = "Flipper length (mm)")

###### Adding Control Flow with if-else #####
## The if-else statement 
a <- 4
b <- 5

if (a > b) {
  f <- 20
} else {
  f <- 10
}

f

## Making your function more flexible 
myplot <- function(data = penguins, x, y, lines = TRUE) {
  pal <- pnw_palette("Lake", 3, type = "discrete")
  
  if (lines == TRUE) {
    ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
      geom_point() +
      geom_smooth(method = "lm") +
      scale_color_manual("Island", values = pal) +
      theme_bw()
  } else {
    ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
      geom_point() +
      scale_color_manual("Island", values = pal) +
      theme_bw()
  }
}

## Test with lines (default)
myplot(x = body_mass_g, y = flipper_length_mm)

## Test without lines 
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)