
#' @importFrom lubridate interval
transform_data <- function(kpi_loss_data_prelim) {

  tenure_breaks <- c(-Inf, 1, 3, 5, 10, Inf)
  tenure_labels <- c("Less than 1 Year",
                     "1 to 3 Years",
                     "3 to 5 Years",
                     "5 to 10 Years",
                     "10+ Years")

  age_breaks <- c(-Inf, 18, 21, 30, Inf)
  age_labels <- c("Less than 18 Years Old",
                  "18 to 21 Years Old",
                  "22 to 30 Years Old",
                  "30+ Years Old")

  # 0, 1-3, 3+
  report_lag_breaks <- c(-1, 0, 3, Inf)
  report_lag_labels <- c("0 Days",
                         "1 to 3 Days",
                         "3+ Days")
  # 0-$50K, $50K-$100K, $100K-$250K and $250K-$500K, $500k+
  incurred_breaks <- c(-1, 50000, 100000, 250000, 500000, Inf)
  incurred_labels <- c("$0-$50K",
                       "$50K-$100K",
                       "$100K-$250K",
                       "$250K-$500K",
                       "$500K+")

  kpi_loss_data_prelim %>%
    dplyr::mutate(
      tenure = lubridate::interval(hire_date, eval_date) / years(1),
      tenure_group = derive_groups(tenure, breaks = tenure_breaks, labels = tenure_labels),
      claimant_age_group = derive_groups(claimant_age, age_breaks, age_labels),
      driver_age_group = derive_groups(driver_age, age_breaks, age_labels),
      report_lag_group = derive_groups(report_lag, report_lag_breaks, report_lag_labels),
      incurred_group = derive_groups(net_total_incurred, incurred_breaks, incurred_labels),
      count = dplyr::if_else(status == "I", 0, 1),
      close_count = dplyr::if_else(status == "C", 1, 0),
      open_count = count - close_count
    ) %>%
    dplyr::select(
      eval_date,
      devt_age,
      occurrence_number,
      coverage,
      member,
      program_year,
      loss_date,
      rept_date,
      hire_date,
      report_lag,
      report_lag_group,
      day_of_week,
      claim_type,
      claimant_state,
      loss_state,
      cause,
      department,
      tenure,
      tenure_group,
      claimant_age,
      claimant_age_group,
      driver_age,
      driver_age_group,
      status,
      total_paid = net_total_paid,
      total_incurred = net_total_incurred,
      count,
      open_count,
      close_count,
      incurred_group
    )

}
