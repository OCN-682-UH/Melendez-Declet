###### Intro to Shiny Apps Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 11/10/2026
# This script is to learn how to work shiny apps 

###### Load Libraries ######
library(shiny)
library(tidyverse)

##### When is Shiny Useful? #####
## When we want to make R code accessible outside of an R or RStudio environment

##### Two Components for Shiny App #####
## The ui (user interface) object dictates the appearance of the app. UI functions write HTML. For something to appear in your app, it needs to be in the UI.

## The server() function contains rendering expressions that create the objects to display.

## The server function and UI object are passed to the shinyApp() function to create a Shiny app object.

##### Our Blank App ######
ui <- fluidPage(
  sliderInput(inputId = "num", # ID name for the input
              label = "Choose a number", # Label above the input
              value = 25, min = 1, max = 100 # values for the slider
  ),
  textInput(inputId = "title", # new Id is title
            label = "Write a title",
            value = "Histogram of Random Normal Values"), # starting title
  plotOutput("hist"), # creates space for a plot called hist
  verbatimTextOutput("stats") # create a space for stats
)

server <- function(input, output){
  
  output$hist <- renderPlot({
    
    # {} allows us to put all our R code in one nice chunk
    data <- reactive({
      tibble(x = rnorm(input$num)) # number of points set by the slider
    })
    
    ggplot(data(), aes(x = x)) + # make a histogram
      geom_histogram()+
      labs(title = input$title) # add a new title
  })
  
  output$stats <- renderPrint({
    base :: summary(data()) # calculate summary stats based on the numbers 
  })
  
}

shinyApp(ui = ui, server = server)
