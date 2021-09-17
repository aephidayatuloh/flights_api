# Load Data ---------------------------------------------------------------

library(nycflights13)
flights
weather
airports

# Sneak peek --------------------------------------------------------------

# library(skimr)
skimr::skim(flights)
skimr::skim(weather)
skimr::skim(airports)

# Some Exploration --------------------------------------------------------

library(dplyr)
flights %>% 
  distinct(origin) %>% 
  left_join(airports, by = c("origin" = "faa"))

flights %>% 
  distinct(dest) %>% 
  left_join(airports, by = c("dest" = "faa"))

flights %>% 
  filter(origin == "JFK" & dest == "IAH" & month == 10)

flights %>% 
  left_join(weather, by = c("year", "month", "day", "hour", "time_hour", "origin"))
