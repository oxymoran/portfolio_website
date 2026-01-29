library(tidyverse)
library(lubridate)

calories <- minuteCaloriesNarrow_merged
mets <- minuteMETsNarrow_merged
sleep <- minuteSleep_merged %>% 
    rename(SleepValue = value)

sleep <- sleep %>%
  distinct(Id, date, .keep_all = TRUE)

intensity <- minuteIntensitiesNarrow_merged
steps <- minuteStepsNarrow_merged

minute_merge <- calories %>% 
  left_join(mets, by = c("Id", "ActivityMinute"))

minute_merge <- minute_merge %>% 
  left_join(intensity, by = c("Id", "ActivityMinute"))

minute_merge <- minute_merge %>% 
  left_join(steps, by = c("Id", "ActivityMinute"))

minute_merge <- minute_merge %>% 
  left_join(sleep, by = c("Id" = "Id", "ActivityMinute" = "date"))

write.csv(minute_merge, "minuteActivity_merged.csv")
