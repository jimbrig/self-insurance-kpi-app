create_summary_by_year <- function(
  loss_data,
  exposure_data,
  eval,
  exposure_type,
  members,
  departments,
  incurred_min_max,
  loss_date_min_max,
  causes,
  days,
  claim_types,
  claimant_states,
  loss_states,
  incurred_groups,
  report_lag_groups,
  use_group_by,
  group_by,
  driver_age_groups
) {

  if (!use_group_by) group_by <- NULL

  exposure_data <- exposure_data %>%
    mutate(expo = .data[[exposure_type]],
           program_year = as.numeric(program_year)) %>%
    select(-payroll, -miles) %>%
    filter(member %in% members,
           program_year <= lubridate::year(eval),
           department %in% departments) %>%
    mutate(program_year = as.character(program_year))

  # filter loss data
  loss_data %>%
    filter(
      eval_date == eval,
      member %in% members,
      department %in% departments,
      total_incurred >= incurred_min_max[1],
      total_incurred <= incurred_min_max[2],
      loss_date >= loss_date_min_max[1],
      loss_date <= loss_date_min_max[2],
      cause %in% causes,
      day_of_week %in% days,
      claim_type %in% claim_types,
      claimant_state %in% claimant_states,
      loss_state %in% loss_states,
      report_lag_group %in% report_lag_groups,
      incurred_group %in% incurred_groups,
      driver_age_group %in% driver_age_groups
    ) %>%
    mutate(
      claim_type = forcats::as_factor(claim_type),
      claim_type = forcats::fct_infreq(claim_type),
      cause = forcats::as_factor(cause),
      cause = forcats::fct_infreq(cause)
    ) %>%
    group_by_at(c("program_year", "member", "department", group_by)) %>%
    summarise_at(vars(total_incurred, total_paid, count, open_count, close_count), sum, na.rm = TRUE) %>%
    ungroup() %>%
    # TODO: decide on left vs full join here
    full_join(exposure_data, by = c("program_year", "member", "department")) %>%
    # left_join(exposure_data, by = c("program_year", "member", "department")) %>%
    arrange(member, program_year) %>%
    mutate(program_year = as.character(program_year)) %>%
    mutate_if(is.numeric, function(x) ifelse(!is.finite(x), 0, x)) %>%
    mutate_if(is.character, function(x) ifelse(is.na(x), "(Missing)", x)) %>% # tidyr::replace_na, "(Missing)") %>%
    mutate_if(is.numeric, round, digits = 3) %>%
    mutate_if(is.factor, forcats::fct_explicit_na) %>%
    group_by_at(c("program_year", group_by)) %>%
    summarise_at(vars(total_incurred, total_paid, count, open_count, close_count, expo), sum, na.rm = TRUE) %>%
    ungroup() %>%
    derive_calcs() # %>%
  # filter(total_incurred + total_paid > 0,
  # expo > 0)

}



create_summary_by_eval <- function(
  loss_data,
  exposure_data,
  eval,
  devt,
  exposure_type,
  members,
  departments,
  incurred_min_max,
  loss_date_min_max,
  causes,
  days,
  claim_types,
  claimant_states,
  loss_states,
  incurred_groups,
  report_lag_groups,
  use_group_by,
  group_by,
  driver_age_groups
) {

  if (!use_group_by) group_by <- NULL

  exposure_data <- exposure_data %>%
    mutate(expo = .data[[exposure_type]],
           program_year = as.numeric(program_year)) %>%
    select(-payroll, -miles) %>%
    filter(member %in% members,
           department %in% departments,
           program_year <= lubridate::year(eval))

  hold <- loss_data %>%
    mutate(program_year = as.numeric(program_year),
           claim_type = forcats::as_factor(claim_type),
           claim_type = forcats::fct_infreq(claim_type),
           cause = forcats::as_factor(cause),
           cause = forcats::fct_infreq(cause)) %>%
    filter(
      month(eval_date) == month(eval),
      eval_date <= eval,
      program_year <= lubridate::year(eval),
      devt_age == devt,
      member %in% members,
      department %in% departments,
      total_incurred >= incurred_min_max[1],
      total_incurred <= incurred_min_max[2],
      loss_date >= loss_date_min_max[1],
      loss_date <= loss_date_min_max[2],
      cause %in% causes,
      day_of_week %in% days,
      claim_type %in% claim_types,
      claimant_state %in% claimant_states,
      loss_state %in% loss_states,
      report_lag_group %in% report_lag_groups,
      incurred_group %in% incurred_groups,
      driver_age_group %in% driver_age_groups
    ) %>%
    group_by_at(c("eval_date", "program_year", "member", "department", group_by)) %>%
    summarise_at(vars(total_incurred, total_paid, count, open_count, close_count), sum, na.rm = TRUE) %>%
    ungroup() %>%
    # TODO: decide on left vs full join here
    full_join(exposure_data, by = c("program_year", "member", "department")) %>%
    # left_join(exposure_data, by = c("program_year", "member", "department")) %>%
    arrange(member, eval_date) %>%
    mutate(program_year = as.character(program_year)) %>%
    mutate_if(is.numeric, function(x) ifelse(!is.finite(x), 0, x)) %>%
    mutate_if(is.character, function(x) ifelse(is.na(x), "(Missing)", x)) %>% # tidyr::replace_na, "(Missing)") %>%
    mutate_if(is.numeric, round, digits = 3) %>%
    mutate_if(is.factor, forcats::fct_explicit_na) %>%
    group_by_at(c("program_year", group_by)) %>%
    summarise_at(vars(total_incurred, total_paid, count, open_count, close_count, expo), sum, na.rm = TRUE) %>%
    ungroup() %>%
    derive_calcs()

  max_year <- dplyr::case_when(
    devt <= 12 ~ 2019,
    devt <= 24 ~ 2018,
    devt <= 36 ~ 2017,
    devt <= 48 ~ 2016,
    devt <= 60 ~ 2015,
    devt <= 72 ~ 2014,
    devt <= 84 ~ 2013,
    devt <= 96 ~ 2012,
    devt <= 108 ~ 2011
  )

  hold %>% mutate(program_year = as.numeric(program_year)) %>%
    filter(program_year <= max_year) %>%
    mutate(program_year = as.character(program_year))
}
