
# install.packages('tidyverse')

library(tidyverse)

library(dplyr)


mtcars

tb_df <- data.frame(
  id = 1:3,
  height = c(1.7, 1.6, 1.8),
  weight = c(70, 73, 80)
)

tb_df
print(tb_df)

tb_df$bmi <- tb_df$height / (tb_df$weight)^2


tb_df


# tibble ------------------------------------------------------------------




tb_df <- tibble(
  id = 1:3,
  height = c(1.7, 1.6, 1.8),
  weight = c(70, 73, 80),
  bmi = height / (weight)^2
)

tb_df

weight

# as tibble ---------------------------------------------------------------

mt_tbl <- as_tibble(mtcars)

mt_tbl

head(mtcars)


mt_tbl <- as_tibble(rownames_to_column(mtcars, var = 'car'))
mt_tbl


# readr -------------------------------------------------------------------

library(readr)

dc <- read_delim("data/dc-wikia-data.csv", delim = ",")

dc
View(dc)








