#' Derive Data for KPI Shiny App
#'
#' This function merges the pre-processed, un-grouped "old" evaluation loss data
#' with the working, grouped "report" data (i.e. the result of \code{\link{merge_data}})
#' to output the final KPI loss data for WC and AL.
#'
#' @param old_data tibble; ungrouped, pre-processed "old" data
#' @param report_data tibble; grouped, merged "report" data
#'
#' @return tibble
#' @export
merge_data <- function(old_data, report_data) {

  evals_in_report_data <- report_data %>% pull_unique("eval_date")
  evals_in_old_data <- old_data %>% pull_unique("eval_date")
  evals_in_both <- evals_in_old_data[evals_in_old_data %in% evals_in_report_data]

  old_data_filt <- old_data %>%
    dplyr::filter(!(eval_date %in% evals_in_both))

  old_data_grouped <- old_data_filt %>%
    group_by_occurrence()

  report_data_for_join <- report_data %>%
    dplyr::filter(eval_date == max(report_data$eval_date)) %>%
    dplyr::select(
      src_tpa,
      claim_number_original,
      claim_number,
      event_number,
      occurrence_number,
      claimant,
      member,
      coverage,
      loss_date,
      rept_date,
      report_lag,
      close_date,
      reopen_date,
      hire_date,
      last_date,
      day_of_week,
      program_year,
      latest_status = status,
      claim_type,
      claimant_state,
      loss_state,
      cause_code,
      cause,
      cause_detail,
      department,
      body_part,
      claimant_age,
      driver_age,
      occupation_driver_name,
      claim_description
    )

  report_data_for_bind <- report_data %>%
    dplyr::select(
      src_tpa,
      eval_date,
      claim_number_original,
      claim_number,
      event_number,
      occurrence_number,
      claimant,
      member,
      coverage,
      loss_date,
      rept_date,
      report_lag,
      close_date,
      reopen_date,
      hire_date,
      last_date,
      day_of_week,
      program_year,
      status,
      claim_type,
      claimant_state,
      loss_state,
      cause_code,
      cause,
      cause_detail,
      department,
      body_part,
      claimant_age,
      driver_age,
      occupation_driver_name,
      claim_description,
      medical_paid:subrogation
    ) %>%
    dplyr::group_by(
      occurrence_number, eval_date
    ) %>%
    # dplyr::arrange(
      # dplyr::desc(eval_date)
    # ) %>%
    dplyr::mutate(
      latest_status = dplyr::first(status, order_by = desc(eval_date))
    ) %>%
    dplyr::ungroup()

  hold <- old_data_grouped %>%
    dplyr::select(eval_date,
                  occurrence_number,
                  status,
                  medical_paid:subrogation) %>%
    dplyr::left_join(report_data_for_join, by = "occurrence_number") %>%
    dplyr::bind_rows(report_data_for_bind)


  incidents_to_remove <- report_data %>%
    filter(eval_date == max(.$eval_date)) %>%
    dplyr::filter(status == "I") %>%
    pull_unique("occurrence_number")

  invalid_members <- c(
    "Invalid",
    "Invalid Member",
    "Fox River",
    "Hansen Foodservice",
    "Appert's Foodservice",
    "Doerle Food Services, L.L.C.",
    "East Coast Fruit Company",
    "Ellenbee-Leggett Co, Inc.",
    "Ettline Foods Corporation",
    "Glazier Foods Company",
    "Hawkeye Foodservice Dist., Inc.",
    "Monterrey Provision Co., Inc",
    "Monterrey Provision Co., Inc.",
    "Nichols Foodservice Inc.",
    "Zanios Foods, Inc."#,
    # "Jake's, Inc."
  )

  max_program_year <- pull_unique(hold, "program_year") %>%
    as.numeric() %>%
    max()

  program_years <- as.character(c(2011:max_program_year))

  hold %>%
    dplyr::mutate(eval_month = lubridate::month(eval_date)) %>%
    dplyr::filter(eval_month %in% c(4, 8, 12),
                  program_year %in% program_years,
                  coverage %in% c("AL", "WC"),
                  !(occurrence_number %in% incidents_to_remove),
                  !(stringr::str_trim(member) %in% invalid_members)) %>%
    dplyr::mutate(wc_jakes = dplyr::if_else(coverage == "WC" & member == "Jake's, Inc.", "excl", "incl")) %>%
    dplyr::filter(
      wc_jakes != "excl"
    ) %>%
    dplyr::select(-wc_jakes) %>%
    dplyr::mutate(
      program_start = lubridate::ymd(paste0(as.numeric(program_year) - 1, "-12-31")),
      devt_age = elapsed_months(eval_date, program_start)
    ) %>%
    dplyr::select(eval_date, devt_age, occurrence_number,
                  coverage, member, program_year,
                  dplyr::everything()) %>%
    dplyr::arrange(occurrence_number, dplyr::desc(eval_date))


}
