

# nycflights13 ------------------------------------------------------------
# class examples relating to the dpylr and tidyr part


library(nycflights13)
data(package = "nycflights13")

# interesting columns
flights %>% 
  select(dep_delay, arr_delay, carrier)
# new table
airlines

# add the "name" of the carrier to the table flights (join)

flights %>% 
  select(dep_delay, arr_delay, carrier) %>% 
  left_join(airlines, by = "carrier")


# rename a column
flights_2 <- flights %>% 
  rename(my_carrier = "carrier") %>% 
  select(dep_delay, arr_delay, my_carrier)

# join specifying the joining columns if they have different names on the two tables
flights_2 %>% 
  left_join(airlines, by = c("my_carrier" = "carrier"))

# join matching by more than one column on both tables
flights %>% 
  left_join(weather, by = c("year", "month", "day", "origin", "hour"))


# create a lower column with repetitions (the classic foreing-key can contain repeted values)
main_tbl <- tibble(
  id = c(1:2, 3, 4:6), #1:5,
  lower = c(letters[1:2], 'non-letter', letters[1:3])
)
# the "lower" column of the right table does not contain repetitions: there is
# no row duplication in the join.
main_tbl %>% 
  left_join(letter_tbl, by = "lower")

# the "lower" column of the right table NOW DOES CONTAIN repetitions: there is
# row duplication in the join!

letter_tbl <- tibble(
  lower = c(letters, letters),
  upper = c(LETTERS, LETTERS)
) %>% 
  arrange(lower)
letter_tbl

main_tbl %>% 
  left_join(letter_tbl, by = "lower")


# lubridate integration ---------------------------------------------------

# In order to use a grouping variable of the month, you can create a string 
# (concatenation of year and month), but in a more useful way you can use the 
# computed last day of the month.

covid_time %>% 
  select(region, datetime) %>% 
  # mutate(mese = paste(year(datetime), month(datetime), sep = "-"))
  mutate(date_month = ceiling_date(datetime, unit = "month") - days(1))

# several ways to go back of one year

covid_time %>% 
  select(region, datetime) %>% 
  # year as a period
  # mutate(a_year_ago =  datetime - years(1))
  # a year as 365 days
  # mutate(a_year_ago =  datetime - days(365))
  # a year as a duration
  mutate(a_year_ago =  datetime - dyears(1))


# remove dollar and spaces from a currency value --------------------------

str_replace_all("10 000 $", pattern = " |\\$", replace = "") %>% 
  as.integer()



