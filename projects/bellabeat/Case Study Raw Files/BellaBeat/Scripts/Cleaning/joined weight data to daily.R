library(tidyverse)
library(lubridate)

daily <- dailyActivity_merged %>% 
  mutate(
    ActivityDate = mdy(ActivityDate),
    ActivityDate = as.Date(ActivityDate)
  )

weight <- weightLogInfo_merged %>% 
  mutate(
    Date = mdy_hms(Date),
    Date = as.Date(Date)
  )


daily_merged <- daily %>% 
  left_join(weight, by = c("Id" = "Id", "ActivityDate" = "Date"))

write.csv(daily_merged, "dailyActivity.csv")