
  ### Load installed packages
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)

### Load CSV files
daily_activity <- read.csv("C:/Users/cmor7/OneDrive/Desktop/Case Study/BellaBeat/Data/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
sleep_day <- read.csv("C:/Users/cmor7/OneDrive/Desktop/Case Study/BellaBeat/Data/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")
hourly_intensities <- read.csv("C:/Users/cmor7/OneDrive/Desktop/Case Study/BellaBeat/Data/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
hourly_calories <- read.csv("C:/Users/cmor7/OneDrive/Desktop/Case Study/BellaBeat/Data/Fitabase Data 4.12.16-5.12.16/hourlyCalories_merged.csv")

### Review head data of loaded CSV files
head(daily_activity)
head(sleep_day)
head(hourly_intensities)
head(hourly_calories)

### Review column names of loaded CSV files
colnames(daily_activity)
colnames(sleep_day)
colnames(hourly_intensities)
colnames(hourly_calories)

### Fix date mismatches
sleep_day <- sleep_day %>% 
  mutate(
    SleepDay = mdy_hms(SleepDay),  # Parse datetime (adjust format if needed)
    Date = as.Date(SleepDay),
  )
head(sleep_day)

daily_activity <- daily_activity %>% 
  mutate(
    ActivityDate = mdy(ActivityDate),
    Date = as.Date(ActivityDate)
  )

hourly_intensities <- hourly_intensities %>% 
  mutate(
    ActivityHour = mdy_hms(ActivityHour),  # Parse datetime (adjust format if needed)
    Date = as.Date(ActivityHour),
    Time = format(ActivityHour, "%H:%M")
  )

hourly_calories <- hourly_calories %>% 
  mutate(
    ActivityHour = mdy_hms(ActivityHour),  # Parse datetime (adjust format if needed)
    Date = as.Date(ActivityHour),
    Time = format(ActivityHour, "%H:%M")
  )

## Summary Statistics
### How many unique participants are there in each dataframe?
n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)
n_distinct(hourly_intensities$Id)
n_distinct(hourly_calories$Id)

### How many observations are there in each dataframe?
nrow(daily_activity)
nrow(sleep_day)
nrow(hourly_intensities)
nrow(hourly_calories)

### daily_activity dataframe:
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes,
         Calories) %>%
  summary()

### sleep_day dataframe:
sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()

### hourly_intensities dataframe:
hourly_intensities %>%  
  select(TotalIntensity,
         AverageIntensity) %>%
  summary()

### hourly_calories dataframe:
hourly_calories %>%  
  select(Calories) %>%
  summary()

## Joining sleep_day and daily_activity
activity_sleep <- full_join(sleep_day, daily_activity, by=c("Id", "Date"))

### Verify Distinct Id Count After Join
n_distinct(activity_sleep$Id)

## Visualization 
ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + geom_point()+ geom_smooth()+ labs(title="Total Steps vs. Sedentary Minutes", y="Total Sedentary Minutes", x="Total Steps")
ggplot(data=daily_activity, aes(x=TotalSteps, y=Calories)) + geom_point() + geom_smooth()+ labs(title="Total Steps vs. Calories", x="Total Steps")
ggplot(data=sleep_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + geom_point()+ geom_smooth()+ labs(title="Total Sleep Minutes vs. Total Time In Bed", y="Total Time in Bed", x="Total Sleep Minutes")
ggplot(data = activity_sleep, aes(x=TotalMinutesAsleep, y=TotalSteps)) + geom_point() + geom_smooth()+ labs(title="Total Sleep Minutes vs. Total Steps", y="Total Steps", x="Total Sleep Minutes")
ggplot(data = activity_sleep, aes(x=TotalMinutesAsleep, y=SedentaryMinutes)) + geom_point() + geom_smooth()+ labs(title="Total Sleep Minutes vs. Total Sedentary Minutes", y="Total Sedentary Minutes", x="Total Sleep Minutes")
ggplot(data = activity_sleep, aes(x=TotalMinutesAsleep, y=Calories)) + geom_point() + geom_smooth() + labs(title="Total Sleep Minutes vs. Calories", x="Total Sleep Minutes")

grouped_hourly_intensities <- hourly_intensities %>%
  group_by(Time) %>%
  drop_na() %>%
  summarise(mean_total_int = mean(TotalIntensity))

ggplot(data=grouped_hourly_intensities, aes(x=Time, y=mean_total_int)) + geom_col(fill='grey', color="darkblue") + theme(axis.text.x = element_text(angle = 45)) + labs(title="Average Total Intensity vs. Time", y="Average Total Intensity")

grouped_hourly_calories <- hourly_calories %>%
  group_by(Time) %>%
  drop_na() %>%
  summarise(mean_calories = mean(Calories))

ggplot(data=grouped_hourly_calories, aes(x=Time, y=mean_calories)) + geom_col(fill='grey', color="darkblue") + theme(axis.text.x = element_text(angle = 45)) + labs(title="Average Calories vs. Time", y="Mean Calories")

## Correlations
# Correlations with p-values
# Sedentary vs Sleep
cor_test_sed_sleep <- cor.test(activity_sleep$SedentaryMinutes, activity_sleep$TotalMinutesAsleep)
print(cor_test_sed_sleep)  # r and p-value

# Steps vs Sedentary
cor_test_steps_sed <- cor.test(daily_activity$TotalSteps, daily_activity$SedentaryMinutes)
print(cor_test_steps_sed)

# Steps vs Calories
cor_test_steps_cal <- cor.test(daily_activity$TotalSteps, daily_activity$Calories)
print(cor_test_steps_cal)

# Sleep vs Time in Bed
cor_test_sleep_bed <- cor.test(sleep_day$TotalMinutesAsleep, sleep_day$TotalTimeInBed)
print(cor_test_sleep_bed)

# Sleep efficiency (ratio) for insomnia outliers
sleep_day$SleepEfficiency <- sleep_day$TotalMinutesAsleep / sleep_day$TotalTimeInBed
mean_eff <- mean(sleep_day$SleepEfficiency, na.rm = TRUE)
std_eff <- sd(sleep_day$SleepEfficiency, na.rm = TRUE)
outliers <- sleep_day[sleep_day$SleepEfficiency < (mean_eff - 2 * std_eff), ]
print(paste("Mean Efficiency:", round(mean_eff, 3), "Std:", round(std_eff, 3), "Outliers:", nrow(outliers)))

# Visualize efficiency
ggplot(sleep_day, aes(x = SleepEfficiency)) + geom_histogram(binwidth = 0.01, color="darkblue", fill="gray") + 
  labs(title = "Distribution of Sleep Efficiency", y = "Number of Sleep Records", x="Sleep Efficiency")