library(tidyverse)

calories <- hourlyCalories_merged
steps <- hourlySteps_merged
intensities <- hourlyIntensities_merged

joined <- left_join(calories, steps, by = c("Id", "ActivityHour"))

joined <- left_join(joined, intensities, by = c("Id", "ActivityHour"))

write.csv(joined, "hourlyActivity_merged.csv")