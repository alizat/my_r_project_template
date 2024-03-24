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



#' Remove columns that are all NA's from dataframe
na_column_killer <- function(df) {
    df[!sapply(df, function(x){all(is.na(x))})]
}



#' Remove constant-valued columns from dataframe
constant_valued_column_killer <- function(df) {
    df[sapply(df, dplyr::n_distinct) > 1]
}



#' Assign a letter based on a score from the range [0, 100]
letter_grader <- function(score, minABCD = c(90, 80, 70, 60)) {
    score <-
        if (score >= minABCD[1]) 'A' else
            if (score >= minABCD[2]) 'B' else
                if (score >= minABCD[3]) 'C' else
                    if (score >= minABCD[4]) 'D' else 'F'
    return(score)
}



#' Generate confusion matrix and accompanying details
confusion_matrix <- function(pred_scores, actuals, threshold = 0.5) {
    cm <-
        tibble(pred_label   = if_else(pred_scores >= threshold, 'GOOD', 'BAD'),
               actual_label = actuals) %>%
        add_row(pred_label = 'BAD',  actual_label = 'BAD') %>%
        add_row(pred_label = 'GOOD', actual_label = 'GOOD') %>%
        table()
    cm["BAD", "BAD"]   <- cm["BAD", "BAD"]   - 1
    cm["GOOD", "GOOD"] <- cm["GOOD", "GOOD"] - 1

    cm_full <-
        cm %>%
        as.data.frame() %>%
        pivot_wider(names_from = actual_label, values_from = Freq) %>%
        mutate(TOTAL = BAD + GOOD) %>%
        add_row(pred_label = 'TOTAL', BAD = sum(.$BAD), GOOD = sum(.$GOOD), TOTAL = sum(.$TOTAL)) %>%
        as.data.frame()

    precision_GOOD <- cm['GOOD','GOOD'] / sum(cm['GOOD',])
    recall_GOOD	   <- cm['GOOD','GOOD'] / sum(cm[,'GOOD'])
    coverage_GOOD  <- sum(cm['GOOD',])  / sum(cm)
    fscore_GOOD    <- (2 * recall_GOOD * precision_GOOD / (recall_GOOD + precision_GOOD)) %>% round(3)

    precision_BAD  <- cm['BAD','BAD']   / sum(cm['BAD',])
    recall_BAD 	   <- cm['BAD','BAD']   / sum(cm[,'BAD'])
    coverage_BAD   <- sum(cm['BAD',])   / sum(cm)
    fscore_BAD    <- (2 * recall_BAD * precision_BAD / (recall_BAD + precision_BAD)) %>% round(3)

    cm_stuff <-
        list(
            cm = cm,
            cm_full = cm_full,
            threshold      = threshold,

            precision_GOOD = precision_GOOD,
            recall_GOOD    = recall_GOOD,
            coverage_GOOD  = coverage_GOOD,
            fscore_GOOD    = fscore_GOOD,

            precision_BAD  = precision_BAD,
            recall_BAD     = recall_BAD,
            coverage_BAD   = coverage_BAD,
            fscore_BAD     = fscore_BAD
        )

    cm_stuff
}

#' Print confusion matrix and its details
print_cm_details <- function(cm_stuff) {

    precision_GOOD <- cm_stuff$precision_GOOD %>% round(3)
    recall_GOOD    <- cm_stuff$recall_GOOD    %>% round(3)
    coverage_GOOD  <- cm_stuff$coverage_GOOD  %>% round(3)
    fscore_GOOD    <- cm_stuff$fscore_GOOD    %>% round(3)

    precision_BAD <- cm_stuff$precision_BAD %>% round(3)
    recall_BAD    <- cm_stuff$recall_BAD    %>% round(3)
    coverage_BAD  <- cm_stuff$coverage_BAD  %>% round(3)
    fscore_BAD    <- cm_stuff$fscore_BAD    %>% round(3)

    print(glue('threshold = {cm_stuff$threshold}'))
    print(glue(''))
    cm_stuff$cm_full %>% print(row.names = FALSE)
    print(glue(''))
    print(glue('precision_GOOD = {precision_GOOD %>% round(3)}'))
    print(glue('   recall_GOOD = {   recall_GOOD %>% round(3)}'))
    print(glue(' coverage_GOOD = { coverage_GOOD %>% round(3)}'))
    print(glue('   fscore_GOOD = {   fscore_GOOD %>% round(3)}'))
    print(glue(''))
    print(glue('precision_BAD = {precision_BAD %>% round(3)}'))
    print(glue('   recall_BAD = {   recall_BAD %>% round(3)}'))
    print(glue(' coverage_BAD = { coverage_BAD %>% round(3)}'))
    print(glue('   fscore_BAD = {   fscore_BAD %>% round(3)}'))
    print(glue(''))

}

#' Plot confusion matrix
draw_confusion_matrix <- function(cm) {

    TN <- cm['BAD', 'BAD']
    FN <- cm['BAD', 'GOOD']
    FP <- cm['GOOD', 'BAD']
    TP <- cm['GOOD', 'GOOD']

    layout(matrix(c(1,1,2)))
    par(mar = c(2,2,2,2))

    ## *************************

    plot(c(100, 345), c(300, 450), type = "n", xlab = "", ylab = "", xaxt = 'n', yaxt = 'n')
    # title('CONFUSION MATRIX', cex.main=2)

    # create the matrix
    text(225, 450, 'Actual', cex = 1.3, font = 2)
    text(186, 440, 'BAD',    cex = 1.2, font = 2)
    text(264, 440, 'GOOD',   cex = 1.2, font = 2)

    text(140, 380, 'Predicted', cex = 1.3, font = 2, srt = 90)
    text(145, 406, 'BAD',       cex = 1.2, font = 2, srt = 90, col = 'darkred')
    text(145, 349, 'GOOD',      cex = 1.2, font = 2, srt = 90, col = 'darkgreen')

    rect(150, 430, 222, 382, col = '#3F97D0')  # upper-left
    rect(228, 430, 300, 382, col = '#F7AD50')  # upper-right
    rect(150, 375, 222, 323, col = '#F7AD50')  # bottom-left
    rect(228, 375, 300, 323, col = '#3F97D0')  # bottom-right

    # add in the cm results
    text(186, 406, TN, cex = 1.6, font = 2, col = 'darkred')
    text(264, 406, FN, cex = 1.6, font = 2, col = 'darkred')
    text(186, 349, FP, cex = 1.6, font = 2, col = 'darkgreen')
    text(264, 349, TP, cex = 1.6, font = 2, col = 'darkgreen')

    # totals
    text(186, 310, TN + FP,            cex = 1.6, font = 2)                              # actual BAD
    text(264, 310, TP + FN,            cex = 1.6, font = 2)                              # actual GOOD
    text(307, 406, TN + FN,            cex = 1.6, font = 2, adj = 0, col = 'darkred')    # predicted BAD
    text(307, 349, TP + FP,            cex = 1.6, font = 2, adj = 0, col = 'darkgreen')  # predicted GOOD
    text(307, 310, TP + TN + FP + FN,  cex = 1.6, font = 2, adj = 0)                     # everything

    ## *************************

    # add in the specifics
    plot(c(100, 0), c(100, 0), type = "n", xlab = "", ylab = "", main = "", xaxt = 'n', yaxt = 'n')
    text(51, 95, 'Metrics', cex = 1.2, font = 2)

    precision_BAD <- TN / (TN + FN)
    recall_BAD    <- TN / (TN + FP)
    fscore_BAD    <- 2 * recall_BAD * precision_BAD / (recall_BAD + precision_BAD)
    text(41, 75, 'Precision',             cex = 1.2, font = 2, col = 'darkred')
    text(41, 65, round(precision_BAD, 3), cex = 1.2,           col = 'darkred')
    text(51, 75, 'Recall',                cex = 1.2, font = 2, col = 'darkred')
    text(51, 65, round(recall_BAD, 3),    cex = 1.2,           col = 'darkred')
    text(61, 75, 'F1',                    cex = 1.2, font = 2, col = 'darkred')
    text(61, 65, round(fscore_BAD, 3),    cex = 1.2,           col = 'darkred')

    text(32, 58, 'BAD',  cex = 1.2, font = 2, col = 'darkred')
    text(70, 58, 'BAD',  cex = 1.2, font = 2, col = 'darkred')

    segments(x0 = 30, y0 = 50, x1 = 72, y1 = 50)

    text(32, 42, 'GOOD', cex = 1.2, font = 2, col = 'darkgreen')
    text(70, 42, 'GOOD', cex = 1.2, font = 2, col = 'darkgreen')

    precision_GOOD <- TP / (TP + FP)
    recall_GOOD    <- TP / (TP + FN)
    fscore_GOOD    <- 2 * recall_GOOD * precision_GOOD / (recall_GOOD + precision_GOOD)
    text(41, 35, 'Precision',              cex = 1.2, font = 2, col = 'darkgreen')
    text(41, 25, round(precision_GOOD, 3), cex = 1.2,           col = 'darkgreen')
    text(51, 35, 'Recall',                 cex = 1.2, font = 2, col = 'darkgreen')
    text(51, 25, round(recall_GOOD, 3),    cex = 1.2,           col = 'darkgreen')
    text(61, 35, 'F1',                     cex = 1.2, font = 2, col = 'darkgreen')
    text(61, 25, round(fscore_GOOD, 3),    cex = 1.2,           col = 'darkgreen')
}
