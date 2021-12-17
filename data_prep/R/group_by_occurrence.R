#' Group by Occurrence
#'
#' Takes claim level loss data and groups it by occurrence.
#'
#' @param data claim level working loss data.frame
#'
#' @export
#' @return a [tibble][tibble::tibble-package]
#' @importFrom dplyr mutate if_else arrange desc select group_by summarise_at ungroup slice summarise left_join mutate_at vars
#' @importFrom lubridate ymd
#' @importFrom openxlsx convertToDate
group_by_occurrence <- function(data) {

  # create a temporary open/closed column for arranging
  data_arranged <- data %>%
    dplyr::mutate(
      open_closed = substr(status, 1, 1),
      open_closed = dplyr::case_when(toupper(open_closed) == "I" ~ 3,
                                     toupper(open_closed) == "C" ~ 2,
                                     TRUE ~ 1)) %>%
    dplyr::arrange(open_closed, dplyr::desc(last_date)) %>%
    dplyr::select(-open_closed)

  data_occ <- data_arranged %>%
    dplyr::group_by(eval_date, occurrence_number) %>%
    dplyr::summarise_at(vars(medical_paid:subrogation), sum, na.rm = TRUE) %>%
    dplyr::ungroup()

  # just get 1 value for each value that should be static.  By getting only
  # one value we avoid the problem where an occurrence with 2 claims with different values for a
  # variable (e.g. status) will be counted twice
  static_vals <- data_arranged %>%
    dplyr::group_by(eval_date, occurrence_number) %>%
    dplyr::slice(1L) %>%
    dplyr::ungroup() %>%
    dplyr::select(-c(medical_paid:subrogation), -close_date, -last_date,
                  -reopen_date, -rept_date, -report_lag)


  # adjust dates: for all dates EXCEPT report date want to take max of all claims
  # in occurrence. For Report date take minimum
  dates_data <- data %>%
    dplyr::select(occurrence_number, eval_date, close_date, last_date,
                  reopen_date, rept_date, report_lag) %>%
    dplyr::group_by(occurrence_number, eval_date) %>%
    dplyr::summarise(close_date = if (all(is.na(close_date))) NA else max(close_date, na.rm = TRUE),
                     last_date = if (all(is.na(last_date))) NA else max(last_date, na.rm = TRUE),
                     reopen_date = if (all(is.na(reopen_date))) NA else max(reopen_date, na.rm = TRUE),
                     rept_date = if (all(is.na(rept_date))) NA else min(rept_date, na.rm = TRUE),
                     report_lag = if (all(is.na(report_lag))) NA else min(as.numeric(report_lag), na.rm = TRUE)) %>%
    dplyr::ungroup()

  data_occ %>%
    dplyr::left_join(static_vals, by = c("eval_date", "occurrence_number")) %>%
    dplyr::left_join(dates_data, by = c("eval_date", "occurrence_number")) %>%
    # convert `clsd_dt` and `last_dt` to NA if the occurrence is open
    dplyr::mutate(open_closed = substr(toupper(status), 1, 1)) %>%
    dplyr::mutate_at(dplyr::vars(close_date, last_date),
                     list(~ifelse(open_closed %in% c("O", "R"), NA_character_, as.character(.)))) %>%
    dplyr::mutate_at(dplyr::vars(close_date, last_date), lubridate::ymd) %>%
    dplyr::select(-open_closed) %>%
    dplyr::mutate(reopen_date = openxlsx::convertToDate(reopen_date, origin = "1970-01-01"),
                  rept_date = lubridate::ymd(as.character(rept_date)))

}
