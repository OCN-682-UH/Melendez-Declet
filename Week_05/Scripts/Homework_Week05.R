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
  write_csv(here("Week_05", "Outputs", "summary_stats_homework.csv"))


###### Graphing Data ######
## Temperature 

# This website taught me how to add a second y axis using sec.axis: 
# https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

TempDepthPlot <- FinalData |>
  ggplot(aes(x = date_min)) +
  geom_line(aes(y = mean_temp),
            color = "#0571b0") +
  scale_y_continuous(
    name = "Mean Temperature (°C)",
    sec.axis = sec_axis(transform = ~ . / 100,
                        name = "Mean Depth (m)")) +
  labs(x = "Time") +
  theme_classic()

TempDepthPlot

## Salinity 
SalDepthPlot <- FinalData |>
  filter(mean_salinity > 29) |> # I only filter that weird data point @ 13:24, the salinity was at 29... something wrong with sensor data 
  ggplot(aes(x = date_min)) +
  geom_line(aes(y = mean_salinity),
            color = "#008837") +
  scale_y_continuous(
    name = "Mean Salinity (PSU)",
    breaks = c(32, 32.5, 33, 33.5, 34, 34.5, 35), 
    sec.axis = sec_axis(transform = ~ . / 100,
    name = "Mean Depth (m)")) +
  labs(x = "Time") +
  theme_classic()
             
SalDepthPlot

## Final Patchwork 
FinalPlot <- TempDepthPlot / SalDepthPlot +
  plot_annotation(tag_levels = 'A')

FinalPlot 
ggsave(here("Week_05", "Outputs", "HomeworkPlot.png"),
       width = 7,
       height = 6)


