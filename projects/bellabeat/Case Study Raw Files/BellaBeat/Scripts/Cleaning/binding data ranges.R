library(tidyverse)

# Bind Hourly Activity
df_a <- hourlyActivity_A
df_b <- hourlyActivity_B

df_combined <- bind_rows(df_a, df_b) %>% 
  select(-...1)

write.csv(df_combined, "hourlyActivity_full.csv", row.names = FALSE)

# Bind Daily Activity
df_a <- dailyActivity_A
df_b <- dailyActivity_B

df_combined <- bind_rows(df_a, df_b) %>% 
  select(-...1, -...2)

write.csv(df_combined, "dailyActivity_full.csv", row.names = FALSE)

# Bind Minute Activity
df_a <- minuteActivity_A
df_b <- minuteActivity_B

df_combined <- bind_rows(df_a, df_b) %>% 
  select(-...1)

write.csv(df_combined, "minuteActivity_full.csv", row.names = FALSE)

# Bind Minute Activity
df_a <- heartrate_seconds_A
df_b <- heartrate_seconds_B

df_combined <- bind_rows(df_a, df_b) 

write.csv(df_combined, "heartrate_seconds_full.csv", row.names = FALSE)