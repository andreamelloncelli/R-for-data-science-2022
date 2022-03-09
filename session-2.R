# read data

dc <- read_csv("data/dc-wikia-data.csv")

spec(dc)

dc <- read_csv("data/dc-wikia-data.csv",
               col_types = cols(
                 page_id = col_double(),
                 name = col_character(),
                 urlslug = col_character(),
                 ID = col_factor(),
                 ALIGN = col_factor(),
                 EYE = col_factor(),
                 HAIR = col_factor(),
                 SEX = col_factor(),
                 GSM = col_character(),
                 ALIVE = col_character(),
                 APPEARANCES = col_double(),
                 `FIRST APPEARANCE` = col_character(),
                 YEAR = col_double()
               ) )
dc



# pipe put the left hand side argument as the first argument of the right hand 
# side function. Therefore the following two expressions have the same result.
dc %>%
  select(name, appearances, sex) 

select(dc, name, appearances, sex) 


# at the end of the pipeline `ds` is not modified, but the new tibble can be
# assigned to `dc_2_female` in this way:
dc_2_female <- dc %>%
  select(name, appearances, sex) %>% 
  filter(sex == "Female Characters")

# use names in `...`
# define a function
myf <- function(...) {
  ell <- list(...)
  ell$a + ell$b
}

# call the function with named arguments
myf(a = 2, b = 3)

