# -----------------------------------------------------------------------
# STRINGR ---------------------------------------------------------------
# -----------------------------------------------------------------------

library(tidyverse)

covid_raw <- read_csv("data/covid-ita-regions.csv")


# Prepare analysis dataset 
covid_tbl <- covid_raw %>%
  select(-c(country, lat, long)) %>%
  rename(region = region_name) %>%
  arrange(time, region)

covid_long <- covid_tbl %>%
  pivot_longer(-c(time, region_code, region), names_to = "stats_name", 
               values_to = "count") 

stats_tbl <- covid_long %>%
  distinct(stats_name)

# All stringr functions start with str_



# GETTING AND SETTING INDIVIDUAL CHARACTERS -------------------------------

# String length
stats_tbl %>%
  mutate(length_name = str_length(stats_name))

# Paste strings
stats_name_tbl <- 
  stats_tbl %>%
  mutate(full_name = str_c("the_", stats_name, "_number"))
stats_name_tbl

# Subset string characters by positition
stats_tbl %>%
  mutate(initial = str_sub(stats_name, start = 1, end = 1),
         sub_2_5 = str_sub(stats_name, start = 2, end = 5),
         first10 = str_sub(stats_name, start = 1, end = 10)) 

# You can also truncate specifying the ellipsis symbol
stats_tbl %>%
  mutate(first_10 = str_trunc(stats_name, 15),
         last_10 = str_trunc(stats_name, 15, side = "left"),
         first_10_ = str_trunc(stats_name, 15, ellipsis = "/"))



# STRING LENGTH AND WHITESPACES ----------------------------------------------------
# Padding
stats_tbl %>%
  mutate(padded = str_pad(stats_name, 30, pad = "-"))

# Combine with str_trunc to control string length
stats_tbl %>%
  mutate(truncated = str_trunc(stats_name, 15, ellipsis = ""),
         padded = str_pad(truncated, 15, side = "right", pad = "_"),
         length_name = str_length(padded))

stats_tbl %>%
  mutate(whitespaces = str_c("  ", stats_name, " "),
         trim = str_trim(whitespaces))


# PATTERN MATCHING --------------------------------------------------------

# Each pattern matching function has the same first two arguments, 
# a character vector of strings to process and a single pattern to match

# DETECT: detects the presence of a pattern and returns a logical vector 
stats_tbl %>%
  mutate(if_totale = str_detect(stats_name, "ed"))

# COUNT: count the number of matches
stats_tbl %>%
  mutate(n_ = str_count(stats_name, "s"))

# REPLACE: replace the first matched pattern
# REPLACE ALL: replace all matched patterns
stats_name_tbl %>%
  mutate(whitespace = str_replace(full_name, pattern = "_", replace = " "),
         whitespaces = str_replace_all(full_name, pattern = "_", replace = " "))


# LOCAL SENSITIVE ---------------------------------------------------------

stats_name_tbl %>%
  mutate(label = str_replace_all(full_name, pattern = "_", replace = " "),
         LABEL = str_to_upper(label),
         Label = str_to_title(label))

