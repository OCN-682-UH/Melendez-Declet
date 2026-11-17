###### HW 12 Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 11/15/2026
# This script is for my Week 12 Homework. Instructions: Use any data set to make a shiny app. Your app must have at least one dynamic figure and one other output (can be anything)

###### Load Libraries ######
library(shiny)
library(tidyverse)

###### Load Data ######
UlvaFieldData <- read_csv("Data/Base de datos_cphr.csv",
                          locale = locale(encoding = "Latin1")) |> # Ask Mica about this 
  mutate(DateTime = mdy_hm(paste(Date, Time)),
         Date_Fixed = mdy(Date)) |> 
  filter(Site_ID == "Collado" |
           Site_ID == "Atravesado" |
           Site_ID == "San Cristobal" |
           Site_ID == "El Palo" |
           Site_ID == "Laurel") |>  # This dataset had other reef sites that I will be not be using, so I filtered the ones I need 
  filter(Date_Fixed >= as.Date("2025-01-01") & 
           Date_Fixed < as.Date("2025-12-31"))

# This dataset contains monthly seawater water quality measurements collected from coral reef sites in La Parguera, Puerto Rico, between January and December 2025. 

####### Creating App #####
# Creating an interactive water quality dashboard for certain La Parguera reef sites used for coral reef restoration. The user can select sampling sites and water quality parameters to look how it has changed throughout 2025. 

ui <- fluidPage(
  titlePanel("La Parguera, Puerto Rico Water Quality Explorer"),
  selectInput(inputId = "Site", # ID name for the input
              label = "Select a Sampling Site:",
              choices = c("All Sites", "Atravesado", "El Palo",
                          "Laurel", "San Cristobal", "Collado"),
              selected = "All Sites" # this is what shows first on the app 
  ),
  selectInput(inputId = "Parameter", # ID name for the input
              label = "Select a Water Quality Parameter:",
              choices = c("Temperature (°C)" = "Temperature_Field",
                          "Salinity (PSU)" = "Salinity", "Dissolved Oxygen (mg/L)" = "DO"),
              selected = "Temperature_Field" # What the app starts with 
  ),
  plotOutput("WaterQualityPlot") # Creates space for the plot
)


## Colors for plot 
pal <- c("Atravesado" = "#9E0142", "El Palo" = "#C51B7D", "Laurel" = "#DE77AE", "San Cristobal" = "#F1B6DA", "Collado" = "#4d9221")

# Creating a function to filter the data to pick the specific samplign site 
server <- function(input, output){
  SiteData <- reactive({
    if (input$Site == "All Sites") {
      UlvaFieldData
    } else {
      UlvaFieldData |>
        filter(Site_ID == input$Site)
    }
  })
  
# After "reactive", I put "if" and "else" for our shiny app so the user can pick different sites. So if "All sites" is used, then the entire dataset is used. If not, the data gets filterd to show the specifc site the user wants 
  
y_label <- reactive({
    switch(input$Parameter,
           "Temperature_Field" = "Temperature (°C)",
           "Salinity" = "Salinity (PSU)",
           "DO" = "Dissolved Oxygen (mg/L)")
    
  })

# Used "switch()". Found this code template on google in the Posit Communtiy.   

  
## Code for Plot in App - Same code as previous plot 
  output$WaterQualityPlot <- renderPlot({
    ggplot(SiteData(), aes(x = Date_Fixed, y = .data[[input$Parameter]], color=Site_ID, group=Site_ID))+
      scale_x_date(
        limits = as.Date(c("2025-1-01", "2025-12-30")),
        date_breaks = "1 month",   
        expand = FALSE,
        date_labels = "%b") + # Formats label (e.g., "Jan"))
      geom_line(linewidth = 0.9) +
      labs(x = "Date", y =y_label())+ # Amazing code. Here I used "y_label() , so I can get the actually y axis label for each specifc parameter with its correct untis  
      geom_point(size = 2) +
      scale_color_manual("Site", values = pal) +
      theme_classic(base_size = 14)+
      theme(legend.position = "bottom",
            legend.text = element_text(size = 12))

  })
}
shinyApp(ui = ui, server = server)


## I love shiny apps! Super cool 

