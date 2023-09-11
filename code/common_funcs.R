#' Read all sheets of an xlsx file
#'
#' @return
#'   If the specified xlsx file contains a single sheet, a data frame is returned.
#'   If there are multiple sheets then a list of data frame is returned (one data
#'   frame for each sheet).
read_entire_xlsx <- function(xlsx_file) {
    all_sheets <- readxl::excel_sheets(xlsx_file)
    all_sheets <-
        all_sheets %>%
        map(~ readxl::read_xlsx(xlsx_file, sheet = .x, col_types = 'text') %>% mutate_all(as.character)) %>%
        set_names(all_sheets)
    if (length(all_sheets) == 1) all_sheets[[1]] else all_sheets
}



#' Is it a number? (more precisely, can x be coerced into a number)
#'
#' @examples
#' is_number(4)    # TRUE
#' is_number('4')  # TRUE
#' is_number('A')  # FALSE
#'
#' is_number(c('5D', '9.5', '18', 'apple', NA, ''))
#' # FALSE  TRUE  TRUE  FALSE  FALSE  FALSE
#'
#' is_number(NA_real_)        # FALSE
#' is_number(c(FALSE, TRUE))  # TRUE  TRUE (because false can be coerced into 0)
is_number <- function(x) {
    suppressWarnings({!is.na(as.numeric(x))})
}



#' Reduce identical consecutive characters in a string into a single character
#'
#' @examples
#' str_squish_consecutive('apple')  # "aple"
#' str_squish_consecutive('   this isss   a    MESSY string.   ')  # "this is a MESY string."
str_squish_consecutive <- function(string) {
    v <- stringr::str_split_1(string, '')
    vr <- rle(v)
    vr$lengths[] <- 1
    stringr::str_squish(paste(inverse.rle(vr), collapse = ''))
}



#' remove columns that are all NA's from dataframe
na_column_killer <- function(df) {
    df[!sapply(df, function(x){all(is.na(x))})]
}



#' remove constant-valued columns that are all NA's from dataframe
constant_valued_column_killer <- function(df) {
    df[sapply(df, dplyr::n_distinct) > 1]
}

#' assigns a letter based on a score from the range [0, 100]
letter_grader <- function(score,
                          minABCD = c(90, 80, 70, 60)) {
    score <-
        if (score >= minABCD[1]) 'A' else
            if (score >= minABCD[2]) 'B' else
                if (score >= minABCD[3]) 'C' else
                    if (score >= minABCD[4]) 'D' else 'F'
    return(score)
}
