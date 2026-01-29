library(tidyverse)
library(lubridate)

# Convert Dailyactivities date format to match other tables
daily_df <- dailyActivity_full

daily_df$ActivityDate <- format(daily_df$ActivityDate, "%m-%d-%y")
  
write.csv(daily_df, "dailyActivities_reformatedDate.csv", row.names = FALSE)

# Parse the datetime and split into date and time for other 3 tavles
heart_df <- heartrate_seconds_full %>%
  mutate(
    Time = mdy_hms(Time),  # Parse "3-6-25 12:00:00AM"
    Time = format(Time, "%I:%M:%S%p"),  # Extract time (e.g., "12:00:00AM")
    Date = format(Time, "%m-%d-%y")  # Format date with leading zeros (e.g., "03-06-25")
  )