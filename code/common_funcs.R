#' Read all sheets of an xlsx file
#'
#' @description \code{read_entire_xlsx()} loads all sheets of a given xlsx file.
#'
#' @param xlsx_file an xlsx file
#'
#' @return
#' If the specified xlsx file contains a single sheet, a data frame is returned.
#' If there are multiple sheets then a list of data frame is returned (one data
#' frame for each sheet).
read_entire_xlsx <- function(xlsx_file) {
    all_sheets <- readxl::excel_sheets(xlsx_file)
    all_sheets <-
        all_sheets %>%
        map(~ readxl::read_xlsx(xlsx_file, sheet = .x, col_types = 'text') %>% mutate_all(as.character)) %>%
        set_names(all_sheets)
    if (length(all_sheets) == 1) all_sheets[[1]] else all_sheets
}

#' Is it a number?
#'
#' @param x the element to determine if it is a number (more precisely, whether
#'   \code{x} can be coerced into a number)
#'
#' @return \code{TRUE} if \code{x} is a number, \code{FALSE} otherwise
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
