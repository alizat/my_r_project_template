## This script is for preparing of data for eda and modeling later.


## ---- INIT ----
suppressMessages({
    library(tidyverse)
    library(lubridate)
    library(plotly)
    library(tictoc)
    library(glue)

    source('code/common_funcs.R')

    options(dplyr.summarise.inform = FALSE)
})



## ---- LOAD DATA ----
# relevant data
dta <- read_rds('data/processed/processed_dta.rds') %>% distinct()



## ---- FEATURE ENGINEERING ----
# add features
features <-
    dta %>%
    mutate(
        y = year(request_date),
        m = month(request_date)
    ) %>%
    mutate_if(is.character, str_squish)

# remove constant-valued columns
features <- constant_valued_column_killer(features)

# remove rows with NAs
features <- drop_na(features)

# remove duplicate rows
features <- distinct(features)

# target variable
features <- features %>% mutate(label = if_else(iscore_value > 650, 'GOOD', 'BAD'))



## ---- SAVE ----
# save data
features %>% write_rds('data/processed/features.rds')
