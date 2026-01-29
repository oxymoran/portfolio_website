library(tidyverse)
library(dplyr)
library(lubridate)

daily <- data.frame(dailyActivity_merged) %>% 
  mutate(
    ActivityDate = mdy(ActivityDate),
    ActivityDate = as.Date(ActivityDate)
  )

sleep <- data.frame(sleepDay_merged) %>% 
  mutate(
    SleepDay = mdy_hms(SleepDay),  # Parse datetime (adjust format if needed)
    SleepDate = as.Date(SleepDay)       # Extract date
  )

sleep <- sleep %>%
  distinct(Id, SleepDate, .keep_all = TRUE)

joined <- left_join(daily, sleep, by = c("Id" = "Id", "ActivityDate" = "SleepDate"))

write.csv(joined, "dailyActivity.csv")

