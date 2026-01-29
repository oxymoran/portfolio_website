library(tidyverse)
library(ggplot2)

# Select subset of daily activity data
df_activity <- data.frame(dailyActivity_full)  %>% 
  select(TotalSteps, TotalDistance, SedentaryMinutes, Calories)


# Select subset of daily sleep data
df_sleep <- data.frame(dailyActivity_full)  %>% 
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed)

# Select subset of daily activity and sleep data
df_activity_sleep <- data.frame(dailyActivity_full)  %>% 
  select(TotalSteps, TotalDistance, SedentaryMinutes, TotalMinutesAsleep, TotalTimeInBed, Calories)


# Plot the relationships from above
ggplot(data = df_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + geom_point() + geom_smooth()
ggplot(data = df_activity, aes(x=TotalSteps, y=Calories)) + geom_point() + geom_smooth()
ggplot(data = df_sleep, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + geom_point() + geom_smooth()
ggplot(data = df_activity_sleep, aes(x=TotalMinutesAsleep, y=TotalSteps)) + geom_point() + geom_smooth()
ggplot(data = df_activity_sleep, aes(x=TotalMinutesAsleep, y=SedentaryMinutes)) + geom_point() + geom_smooth()
ggplot(data = df_activity_sleep, aes(x=TotalMinutesAsleep, y=Calories)) + geom_point() + geom_smooth()