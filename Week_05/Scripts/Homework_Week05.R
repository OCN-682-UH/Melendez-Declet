###### Advanced Plotting Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 09/25/2026 
# This script is my homework assignment for Week 05 

###### Load Libraries #####
library(tidyverse) 
library(here)
library(patchwork)

###### Load Data ######
CondData <- read_csv(here("Week_05", "Data", "CondData.csv"))
DepthData <-read_csv(here("Week_05", "Data", "DepthData.csv"))

###### Convert Date Columns #####
# For my conductivity data, I need to round the data to the nearest 10 secs to match depth data 
CondData <- CondData |> 
  mutate(date = mdy_hms(date)) |> 
  mutate(date = round_date(date, "10 seconds"))

DepthData <- DepthData |> 
  mutate(date = ymd_hms(date))

###### Combine Data & Conduct Summary Stats ######

FinalData <- CondData |> 
  inner_join(DepthData, by = "date") |> # Exact matches 
  mutate(date_min = round_date(date, "minute")) |> #Round to minute 
  group_by(date_min) |> 
  summarise(mean_depth= mean(Depth, na.rm = TRUE),
            mean_temp = mean(Temperature, na.rm = TRUE),
            mean_salinity = mean(Salinity, na.rm = TRUE)) |> 
  write_csv(here("Week_05", "Outputs", "summary_stats_homework.csv")) # Just to practice 


###### Graphing Data ######
## Temperature 

TempPlot <- FinalData |>
  ggplot(aes(x = date_min,
             y = mean_temp)) +
  geom_line(color = "#0571b0") +
  labs(x = "Time",
       y = "Mean Temperature (°C)") +
  theme_classic() +
  theme(
    axis.text.x = element_blank(), # This removes the x axis label and the values, doing this becuase I have a big patchwork 
    axis.title.x = element_blank())

TempPlot

## Salinity 
SalPlot <- FinalData |>
  ggplot(aes(x = date_min,
             y = mean_salinity)) +
  geom_line(color = "#008837") +
  labs(x = "Time",
       y = "Mean Salinity (PSU)") +
  theme_classic() +
  theme(axis.text.x = element_blank(), # Doing this for the patchwork 
    axis.title.x = element_blank())

SalPlot

## Depth 
DepthPlot <- FinalData |>
  filter(mean_depth > 0.2) |> # Trying to filter the timepoint when the logger maybe wasn't deployed yet 
  ggplot(aes(x = date_min,
             y = mean_depth)) +
  geom_line() + # Didn't add color here b/c I thought black would look nice with blue and green 
  labs(x = "Time",
       y = "Mean Depth (m)") +
  theme_classic() 

DepthPlot

## Final Patchwork 
FinalPlot <- TempPlot / SalPlot / DepthPlot +
  plot_annotation(tag_levels = 'A') # Add the letters to each plot 

FinalPlot 
ggsave(here("Week_05", "Outputs", "Week5HomeworkPlot.png"),
       width = 5,
       height = 8)


