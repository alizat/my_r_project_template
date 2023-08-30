read_entire_xlsx <- function(xlsx_file) {
    all_sheets <- readxl::excel_sheets(xlsx_file)
    all_sheets <-
        all_sheets %>%
        map(~ readxl::read_xlsx(xlsx_file, sheet = .x, col_types = 'text') %>% mutate_all(as.character)) %>%
        set_names(all_sheets)
    if (length(all_sheets) == 1) all_sheets[[1]] else all_sheets
}

is_number <- function(x) {
    suppressWarnings({!is.na(as.numeric(x))})
}

equals_na <- function(a, b) {
    if_else(a == b | (is.na(a) & is.na(b)),  TRUE, FALSE) %>% replace_na(FALSE)
}
