#' @importFrom dplyr mutate mutate_all select everything
#' @importFrom janitor clean_names
#' @importFrom lubridate ymd
#' @importFrom openxlsx read.xlsx
#' @importFrom stringr str_sub
extract_raw <- function(file) {

  message("Extracting raw data from file: ", file)

  eval_date <- file %>%
    basename() %>%
    stringr::str_sub(1, 10) %>%
    lubridate::ymd()

  openxlsx::read.xlsx(
    file, detectDates = FALSE
  ) %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      src_tpa = "old",
      eval_date = eval_date
    ) %>%
    dplyr::mutate_all(as.character) %>%
    dplyr::select(src_tpa, eval_date, dplyr::everything())

}
