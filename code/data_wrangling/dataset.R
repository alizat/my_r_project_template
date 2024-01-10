## This script is for initial data processing of raw data for convenience & ease
## of retrieval and use later. Processed data is saved in 'data/processed'.


## ---- INIT ----
suppressMessages({
    library(tidyverse)
    library(lubridate)
    library(plotly)
    library(tictoc)
    library(glue)

    options(dplyr.summarise.inform = FALSE)
})



## ---- LOAD DATA ----
# relevant data
dta <- read_csv('dta.csv')



## ---- PROCESSING ----
# adjust column names & types
processed_dta <-
    dta %>%
    rename(
        application_id = app_id,
        customer_id    = cust_id
    ) %>%
    mutate(
        application_id = as.character(application_id),
        customer_id    = as.character(customer_id),
        request_date   = as_date(application_id)
    )



## ---- SAVE ----
# save data
processed_dta %>% write_rds('data/processed/processed_dta.rds')
