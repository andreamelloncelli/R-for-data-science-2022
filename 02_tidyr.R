# INTRO -------------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(ggplot2)




# DATA and FIRST EXPLORATIONS ---------------------------------------------

covid_raw <- readRDS("data/covid-ita-regions.Rds")

# Several Covid-19 indicators by date and region - Italy

# Quick data check
glimpse(covid_raw)
summary(covid_raw)

# We can note that:
# data is a factor, that contains the timestamp
# country has a unique value (ITA)
# casi_testati has several NAs
# note_it and note_en is often empty

#   -----------------------------------------------------------------------
# TIDYR ---------------------------------------------------------------
#   -----------------------------------------------------------------------

# SEPARATE AND UNITE ------------------------------------------------------

# SEPARATE different values stored in a sigle column

covid_small <- covid_raw %>%
  select(time, country, region_code, confirmed)

covid_small <- covid_small %>% 
  separate(time, into = c("date", "daytime"), sep = " ", 
           remove = F #default T, remove the original column
  )

# UNITE multiple values stored in different columns

covid_small <- covid_small %>%
  unite(country, region_code, col = "id_zone", sep = "-")


covid_small


# PIVOTING ----------------------------------------------------------------

# PIVOT LONGER

# Dataset in long form: better for analysis and plotting with ggplot2
# In covid_raw we have several stats in different columns

covid_tbl <- read_csv("data/covid-ita-regions.csv")

glimpse(covid_tbl)


# Focus on covid-19 status 
covid_status <- covid_tbl %>% 
  select(time, region = region_name, confirmed, recovered, deaths) %>% 
  arrange(time, region)

# Long version
status_long <- covid_status %>%
  pivot_longer(-c(time, region), names_to = "status", values_to = "count")

# Long version is easier to handle - Plot demo 
status_long %>%
  ggplot(aes(x = time, y = count, col = status)) +
  geom_line() +
  facet_wrap(. ~ region, scales = "free_y") +
  theme_bw()



# PIVOT WIDER

# Dataset in wide form: better for data presentation
status_wide <- status_long %>%
  pivot_wider(names_from = status, values_from = count)

# Demo
covid_tbl %>%
  mutate(month = month(time, label = T)) %>%
  group_by(month, region_name) %>%
  summarise(hosp = sum(hosp)) %>%
  pivot_wider(names_from = month, values_from = hosp)




