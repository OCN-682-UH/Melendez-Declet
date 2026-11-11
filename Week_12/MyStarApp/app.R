###### Intro to Shiny Apps Script - Practice #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 11/10/2026
# This script is to learn how to work shiny apps 

###### Load Libraries ######
library(shiny)
library(tidyverse)

###### Load Data ######
stars <- read_csv("Data/stars.csv")

glimpse(stars)


###### Practice App ######
ui <- fluidPage(
  selectInput(inputId = "min_stars", # ID name for the input
              label = "Show sites with at least this many sea stars:",
              choices = c(1, 5, 10, 20), # threshold options
              selected = 5 # the threshold that shows first
  ),
  plotOutput("star_map") # creates space for the map
)

server <- function(input, output){
  
  kept_sites <- reactive({
    stars |>
      # selectInput returns choices as STRINGS, so convert back to numeric!
      filter(star_no >= as.numeric(input$min_stars)) # sites above threshold
  })
  
  output$star_map <- renderPlot({
    ggplot(kept_sites(), aes(x = long, y = lat)) +
      geom_point(aes(size = star_no), color = "red") + # points sized by count
      labs(size = "Sea stars counted")
  })
}
shinyApp(ui = ui, server = server)



