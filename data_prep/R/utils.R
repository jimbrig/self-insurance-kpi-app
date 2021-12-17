#' Extract Date
#'
#' Extracts dates from a character string with format "mm-dd-yyyy" or "mm/dd/yyyy".
#'
#' @param string character string
#'
#' @return date object
#' @export
#'
#' @examples
#' extract_date("data-raw/lossrun-as-of-2019-01-31.xlsx")
#' @importFrom lubridate mdy
#' @importFrom stringr str_extract_all
extract_date <- function(string) {

  paste0(
    unlist(
      stringr::str_extract_all(
        string,
        "[0-9]{1,2}[-./][0-9]{1,2}[-./][0-9]{2,4}"
      ),
      recursive = TRUE
    ),
    collapse = ""
  ) %>%
    lubridate::mdy() %>%
    as.character()

}

#' Extract numbers from a string
#'
#' @param string String to pull numbers from
#'
#' @return String of numbers
#' @export
#' @importFrom stringr str_extract
extract_num <- function(string){
  stringr::str_extract(string, "\\-*\\d+\\.*\\d*")
}

#' Elapsed Months
#'
#' Derive the number of months elapsed between two dates.
#'
#' @param end_date end date
#' @param start_date start date
#'
#' @return numeric
#' @export
elapsed_months <- function(end_date, start_date) {
  ed <- as.POSIXlt(end_date)
  sd <- as.POSIXlt(start_date)
  12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}


#' Pull Unique Values from a dataframe
#'
#' @param df Dataframe
#' @param var Quoted named of variable
#'
#' @return Character vector of unique, sorted values from specified column
#' @export
pull_unique <- function(df, var){
  df[[var]] %>%
    unique() %>%
    sort()
}

#' Coalesce Join
#'
#' @param x x
#' @param y y
#' @param by by
#' @param suffix suffix
#' @param join join type
#' @param ... passed to dplyr join function
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom dplyr union coalesce bind_cols
#' @importFrom purrr map_dfc
coalesce_join <- function(x,
                          y,
                          by = NULL,
                          suffix = c(".x", ".y"),
                          join = dplyr::full_join,
                          ...) {

  joined <- join(y, x, by = by, suffix = suffix, ...)

  # names of desired output
  cols <- dplyr::union(names(x), names(y))

  to_coalesce <- names(joined)[!names(joined) %in% cols]

  suffix_used <- suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]

  # remove suffixes and deduplicate
  to_coalesce <- unique(
    substr(
      to_coalesce,
      1,
      nchar(to_coalesce) - nchar(suffix_used)
    )
  )

  coalesced <- purrr::map_dfc(
    to_coalesce, ~ dplyr::coalesce(joined[[paste0(.x, suffix[1])]],
                                   joined[[paste0(.x, suffix[2])]])
  )

  names(coalesced) <- to_coalesce

  dplyr::bind_cols(joined, coalesced)[cols]

}

#' To Proper
#'
#' @param string string to manipulate on
#' @param replace_underscores Logical: if \code{TRUE} replaces all underscores
#'   with specified \code{underscore_replacement} argument's value.
#' @param underscore_replacement Character: if argument \code{replace_underscores}
#'  equals \code{TRUE}, will replace all "_"'s with specified string.
#' @param return_as How should the string be returned? Options are:
#'   \itemize{
#'   \item{"titlecase"}: Applies \code{stringr::str_to_title}.
#'   \item{"uppercase"}: Applies \code{toupper}.
#'   \item{"lowercase"}: Applied \code{tolower}.
#'   \item{"asis"}: No manipulation. Returns as is.
#'   }
#'
#' @seealso \code{\link[stringr]{str_replace}}.
#'
#' @return "Proper" string
#' @export
#'
#' @examples
#' s <- "variable_a is awesome"
#' toproper(s)
#'
#' @importFrom stringr str_replace_all str_to_title
toproper <- function(string,
                     replace_underscores = TRUE,
                     underscore_replacement = " ",
                     return_as = c("titlecase", "uppercase", "lowercase", "asis"),
                     uppers = c("Tpa")) {

  return_as = match.arg(return_as, several.ok = FALSE)

  if (replace_underscores) {
    string <- stringr::str_replace_all(string, pattern = "_", replacement = underscore_replacement)
  }

  if (return_as == "asis") return(string)

  hold <- switch(
    return_as,
    titlecase = stringr::str_to_title(string),
    uppercase = toupper(string),
    lowercase = tolower(string)
  )

  stringr::str_replace_all(hold, uppers, toupper(uppers))

}

#' old_data_utils
#'
#' Functions to help ease the data processing pipeline for "old" evaluation
#' loss runs.
#'
#' @name old_data_utils
NULL

#' @describeIn old_data_utils Filter unnecessary rows from initial raw data
#'
#' @importFrom dplyr filter
#' @importFrom stringr str_detect fixed str_trim
filter_data <- function(data) {

  data %>%
    dplyr::filter(
      !stringr::str_detect(occurrence_number, stringr::fixed("PLACE")),
      occurrence_number != "0",
      !stringr::str_detect(stringr::str_trim(event_number), stringr::fixed("Claims")),
      !stringr::str_detect(stringr::str_trim(claim_number), stringr::fixed("Grand Totals:")),
      !stringr::str_detect(stringr::str_trim(claim_number), stringr::fixed("-1-"))
    )

}

#' @describeIn old_data_utils Clean dates for initial raw data
#'
#' @importFrom dplyr mutate if_else coalesce select
#' @importFrom lubridate as_date mdy
#' @importFrom openxlsx convertToDate
#' @importFrom stringr str_detect fixed
#' @importFrom tidyselect contains
clean_dates <- function(data) {

  data %>% dplyr::mutate(
    eval_date = lubridate::as_date(eval_date),
    loss_date_lub = dplyr::if_else(stringr::str_detect(loss_date, stringr::fixed("/")), loss_date, NA_character_),
    loss_date_lub = lubridate::mdy(loss_date_lub),
    loss_date_num = dplyr::if_else(is.na(loss_date_lub), loss_date, NA_character_),
    loss_date_num = openxlsx::convertToDate(as.integer(loss_date_num)),
    loss_date_clean = dplyr::coalesce(loss_date_lub, loss_date_num),
    loss_date = loss_date_clean,
    close_date_lub = dplyr::if_else(stringr::str_detect(close_date, stringr::fixed("/")), close_date, NA_character_),
    close_date_lub = lubridate::mdy(close_date_lub),
    close_date_num = dplyr::if_else(is.na(close_date_lub), close_date, NA_character_),
    close_date_num = openxlsx::convertToDate(as.integer(close_date_num)),
    close_date_clean = dplyr::coalesce(close_date_lub, close_date_num),
    close_date = close_date_clean,
    last_close_date_lub = dplyr::if_else(stringr::str_detect(last_close_date, stringr::fixed("/")), last_close_date, NA_character_),
    last_close_date_lub = lubridate::mdy(last_close_date_lub),
    last_close_date_num = dplyr::if_else(is.na(last_close_date_lub), last_close_date, NA_character_),
    last_close_date_num = openxlsx::convertToDate(as.integer(last_close_date_num)),
    last_close_date_clean = dplyr::coalesce(last_close_date_lub, last_close_date_num),
    last_close_date = last_close_date_clean,
    reopen_date = dplyr::coalesce(reopen_date, re_open_date),
    reopen_date_lub = dplyr::if_else(stringr::str_detect(reopen_date, stringr::fixed("/")), reopen_date, NA_character_),
    reopen_date_lub = lubridate::mdy(reopen_date_lub),
    reopen_date_num = dplyr::if_else(is.na(reopen_date_lub), reopen_date, NA_character_),
    reopen_date_num = openxlsx::convertToDate(as.integer(reopen_date_num)),
    reopen_date_clean = dplyr::coalesce(reopen_date_lub, reopen_date_num),
    reopen_date = reopen_date_clean,
    tenure_date_of_hire_lub = dplyr::if_else(stringr::str_detect(tenure_date_of_hire, stringr::fixed("/")), tenure_date_of_hire, NA_character_),
    tenure_date_of_hire_lub = lubridate::mdy(tenure_date_of_hire_lub),
    tenure_date_of_hire_num = dplyr::if_else(is.na(tenure_date_of_hire_lub), tenure_date_of_hire, NA_character_),
    tenure_date_of_hire_num = openxlsx::convertToDate(as.integer(tenure_date_of_hire_num)),
    tenure_date_of_hire_clean = dplyr::coalesce(tenure_date_of_hire_lub, tenure_date_of_hire_num),
    tenure_date_of_hire = tenure_date_of_hire_clean
  ) %>%
    dplyr::select(
      -re_open_date,
      -tidyselect::contains("_lub"),
      -tidyselect::contains("_date_num"),
      -tidyselect::contains("_clean")
    )

}

#' @describeIn old_data_utils Convert numeric fields
#'
#' @importFrom dplyr mutate_at vars
#' @importFrom readr parse_number
#' @importFrom tidyselect contains
convert_numerics <- function(data) {

  data %>%
    dplyr::mutate_at(dplyr::vars(program_year, subrogation_amount, report_lag_days,
                                 tidyselect::contains("paid_"),
                                 tidyselect::contains("incurred_"),
                                 o_s_reserve_total),
                     readr::parse_number)
}

#' @importFrom forcats as_factor fct_explicit_na
derive_groups <- function(x, breaks, labels) {

  x %>%
    cut(breaks = breaks, labels = labels) %>%
    forcats::as_factor() %>%
    forcats::fct_explicit_na()

}

#' Convert xls to xlsx
#'
#' @param dir directory
#' @param dest_dir destination directory
#'
#' @return invisible
#' @export
#'
#' @importFrom fs dir_exists dir_ls path path_ext_remove
#' @importFrom rio convert
convert_xls_to_xlsx <- function(dir, dest_dir = dir) {

  stopifnot(fs::dir_exists(dir))
  files <- fs::dir_ls(dir)
  to_files <- fs::path(paste0(dest_dir, "/", fs::path_ext_remove(basename(files))))
  message("Converting from ", x, " to ", to)
  rio::convert(x, to, in_opts = list(col_types = "text"))
  return(invisible())

}



