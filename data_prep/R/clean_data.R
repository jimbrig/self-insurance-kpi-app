#' @importFrom dplyr filter mutate select bind_rows mutate_if case_when
#' @importFrom stringr str_trim str_sub str_remove_all
clean_data <- function(raw_data) {

  # NOTE: for evals 2011-04-30, 2011-08-31, 2011-11-30, 2011-12-31, and 2012-04-30,
  #       columns claim description and paid_med_bi_comp need to be switched;
  #       incorrectly labelled in original loss runs

  evals_to_adjust <- c("2011-04-30",
                       "2011-08-31",
                       # "2011-11-30",
                       "2011-12-31",
                       "2012-04-30")

  # fix cols for evals_to_adjust
  data_adjusted <- raw_data %>%
    dplyr::filter(eval_date %in% evals_to_adjust) %>%
    dplyr::mutate(paid_med_bi_comp_temp = claim_description,
                  claim_description = paid_med_bi_comp,
                  paid_med_bi_comp = paid_med_bi_comp_temp) %>%
    dplyr::select(-paid_med_bi_comp_temp) %>%
    dplyr::bind_rows(
      raw_data %>%
        dplyr::filter(!(eval_date %in% evals_to_adjust))
    )

  hold <- data_adjusted %>%
    # filter out place holders
    filter_data() %>%
    # transform dates
    clean_dates() %>%
    # convert numerics
    convert_numerics() %>%
    # trim characters
    dplyr::mutate_if(is.character, stringr::str_trim) %>%
    # derive report date from lag and day_of week
    dplyr::mutate(
      rept_date = loss_date + report_lag_days,
      day_of_week = weekdays(loss_date, abbreviate = FALSE),
      coverage = dplyr::case_when(
        coverage == "Worker's Compensation" ~ "WC",
        coverage == "General Liability" ~ "GL",
        coverage == "Auto Liability" ~ "AL",
        coverage == "Auto Physical Damage" ~ "APD",
        coverage == "Products Liability" ~ "PR"
      ),
      status = dplyr::case_when(
        status == "Final" ~ "C",
        TRUE ~ stringr::str_sub(status, 1, 1)
      ),
      claim_number_original = stringr::str_remove_all(
        stringr::str_remove_all(claim_number, " "), "-"),
      net_total_incurred = incurred_total,
      net_total_paid = paid_total,
      total_recovery = paid_recov,
      total_incurred = net_total_incurred + total_recovery,
      total_paid = net_total_paid + total_recovery
    )  %>%
    # select only the fields we need
    dplyr::select(
      src_tpa,
      eval_date,
      claim_number_original,
      claim_number,
      event_number,
      occurrence_number,
      claimant = claimant_name,
      member,
      coverage,
      # claim_type,
      loss_date,
      rept_date,
      close_date,
      reopen_date,
      hire_date = tenure_date_of_hire,
      last_date = last_close_date,
      day_of_week,
      report_lag = report_lag_days,
      program_year,
      # claimant_state,
      # loss_state,
      # cause_code,
      # cause,
      # cause_detail,
      # body_part,
      # claimant_age,
      # driver_age,
      # occupation_driver_name,
      status,
      medical_paid = paid_med_bi_comp,
      medical_incurred = incurred_med_bi_comp,
      indemnity_paid = paid_ind_pd_coll,
      indemnity_incurred = incurred_ind_pd_coll,
      expense_paid = paid_expense,
      expense_incurred = incurred_expense,
      total_paid, #= paid_total,
      total_reserve = o_s_reserve_total,
      total_incurred, # = incurred_total,
      total_recovery, # = incurred_recov,
      net_total_paid,
      net_total_incurred,
      subrogation = subrogation_amount #,
      # claim_description
    ) %>%
    dplyr::mutate(
      src_tpa = dplyr::case_when(
        as.numeric(program_year) == 2005 ~ "Travelers",
        as.numeric(program_year) <= 2010 ~ "Liberty",
        as.numeric(program_year) > 2010 ~ "Sedgwick"
      )
    )
}
