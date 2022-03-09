# INTRO -------------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(ggplot2)




# DATA and FIRST EXPLORATIONS ---------------------------------------------

# covid_raw <- readRDS("data/covid-ita-regioni.csv") 
covid_raw <- readRDS("data/covid-ita-regions.Rds")

# Several Covid-19 indicators by date and region - Italy

# Quick data check
# glimpse(covid_raw)
# summary(covid_raw)

# We can note that:
# data is a factor, that contains the timestamp
# stato has a unique value (ITA)
# casi_testati has several NAs
# note_it and note_en is often empty



# *************************************************************************
# LUBRIDATE ---------------------------------------------------------------
# *************************************************************************



# _ Parsing date and time ---------------------------------------------------

# Extreme example from lubridate package help
x <- c(20100101120101, 
       "2009-01-02 12-01-02", 
       "2009.01.03 12:01:03",
       "2009-1-4 12-1-4",
       "2009-1, 5 12:1, 5",
       "200901-08 1201-08",
       "2009 arbitrary 1 non-decimal 6 chars 12 in between 1 !!! 6",
       "OR collapsed formats: 20090107 120107 (as long as prefixed with zeros)",
       "Automatic wday, Thu, detection, 10-01-10 10:01:10 and p format: AM",
       "Created on 10-01-11 at 10:01:11 PM")
ymd_hms(x)

# Parsing mechanism
x <- c("23/12/2013", "07/10/2014")
dmy(x)

# Handling truncation
x <- c("2011-12-31 12:59:59", "2010-01-01 12:11", "2010-01-01 12", "2010-01-01")
ymd_hms(x, truncated = 3) #up to 3 elements may be missing

# Application on Covid data
covid_time <- covid_raw %>% 
  select(region = region_name, time) %>%
  mutate(datetime = ymd_hms(time))

# If we don't specify the time zone, UTC is assumed


# _ Working with time-zones -------------------------------------------------

# CONVERT TIME ZONES
covid_time %>%
  mutate(datetime_tz = ymd_hms(time, tz = "CET"),
         chicago_time = with_tz(datetime, "America/Chicago"),
         chicago_time2 = with_tz(datetime_tz, "America/Chicago"))
# chicago_time is wrong, since it assumes we are in UTC timezone

# Accepted time-zones names
OlsonNames() # see help for more

# FIX TIME-ZONES 
# We can fix the initial mistake forcing the time-zone
covid_time <- covid_time %>%
  mutate(datetime = force_tz(datetime, tzone = "Europe/Rome"))




# _ Setting and extracting info ---------------------------------------------

covid_time %>%
  mutate(date = date(datetime),
         hour = hour(datetime),
         weekday = wday(date, label = T),
         month = month(date, label = T))





# TIME SPAN AND ARITHMETIC ------------------------------------------------


# INTERVAL: time span between specific dates
covid_phase <- covid_time %>%
  mutate(today = today(tzone = "CET"),
         start_phase2 = ymd("2020-05-04", tz = "CET"),
         phase2 = interval(start_phase2, today),
         in_phase2 = datetime %within% phase2)

# Interval object have several helpers: int_start(), int_end(), int_shift() ...
# See interval() help for more


# DURATIONS: time duration in seconds 
# Duration helper functions are named after the units of time, but start with a d
dminutes(3) # length of 2 minutes
class(dminutes(3))

# PERIODS: time duration, adjusted to be more readable 
# Period helper functions are named after the units of time, but plural
minutes(3)
class(minutes(3))

# You can use duration and periods to do date arithmetic
ymd(20110101) + years(1) # More intuitive
ymd(20110101) + dyears(1) # More precise

# Operation with dates
covid_phase <- covid_phase %>%
  mutate(yesterday = today - days(1),
         two_weeks_later = datetime + weeks(2),
         length_phase2_d = phase2/days(1), # length in days
         length_phase2_w = phase2/weeks(1) # length in weeks
  )

# Months arithmetic is not so obvious. 
# Try to be sure about what you want

# If adding or subtracting a month or a year creates an invalid date, 
# in this case 'lubridate' will return an NA.
mar31 <- ymd(20190331)
mar31 + months(1)

# %m+% AND %m-% OPERATORS
# If necessary, they roll back dates to the last day of the month
mar31 %m+% months(1)
mar31 %m-% months(1)

# If you want to add 31 days, then it's still different:
mar31 + days(31)


# ROUNDING DATES

covid_phase <- covid_phase %>%
  mutate(date_month = floor_date(datetime, unit = "month"))

# Useful for summary stats


# datetime to string ------------------------------------------------------

datetime <- ymd_hms("2011-12-31 12:59:59")

format(datetime, "%Y-W%U")  # 2020-W01 Year-Week
# see help(strptime) for the %codes
# dates help(format.Date), 
# date-times help(format.POSIXct)

# Using stamp

# 1. Derive a template, create a function
# Tip: use a date with day > 12
sf <- stamp("Created Sunday, Jan 17, 1999 3:34")
# sf <- stamp("Created Domenica, Gen 17, 1999 3:34")

# 2. Apply the template to dates
sf(ymd("2010-04-05"))
#> [1] "Created Monday, Apr 05, 2010 00:00"

