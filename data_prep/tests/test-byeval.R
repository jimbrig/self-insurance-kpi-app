

library(DT)
library(highcharter)
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
library(stringr)



source("R/utils.R")
source("R/coverage_tab_module.R")
source("R/header_buttons_module.R")
source("R/shinytools.R")

loss_data <- readRDS("data/kpi_loss_data.RDS") %>% filter(coverage == "AL")
# exposure_data <- readRDS("data/exposure_data.RDS")
exposure_data <- readRDS("data/new_exposures.RDS")

loss_data <- loss_data %>% mutate_at(vars(member, department, cause, day_of_week,
                                              claim_type, claimant_state, loss_state,
                                              report_lag_group, incurred_group), as.character) %>%
  mutate_at(vars(member, department, cause, day_of_week,
                 claim_type, claimant_state, loss_state,
                 report_lag_group, incurred_group), tidyr::replace_na, "(Missing)")

# payroll_data <- readRDS()

eval <- lubridate::ymd("2019-12-31")
devt <- 12
exposure_type <- "miles"
members <- pull_unique(loss_data, "member")
departments <- pull_unique(loss_data, "department")
incurred_min_max <- c(0, 10000000)
loss_date_min_max <- c(min(loss_data$loss_date), max(loss_data$loss_date))
causes <- pull_unique(loss_data, "cause")
days <- pull_unique(loss_data, "day_of_week")
claim_types <- pull_unique(loss_data, "claim_type")
claimant_states <- pull_unique(loss_data, "claimant_state")
loss_states <- pull_unique(loss_data, "loss_state")
incurred_groups <- pull_unique(loss_data, "incurred_group")
report_lag_groups <- pull_unique(loss_data, "report_lag_group")
use_group_by <- TRUE
group_by <- "cause"

if (!use_group_by) group_by <- NULL

exposure_data_hold <- exposure_data %>%
  mutate(expo = .data[[exposure_type]],
         program_year = as.numeric(program_year)) %>%
  select(-payroll, -miles) %>%
  filter(member %in% members,
         department %in% departments,
         program_year <= lubridate::year(eval))


forcats::fct_explicit_na



hold <- loss_data %>%
  mutate(program_year = as.numeric(program_year)) %>%
  filter(
    month(eval_date) == month(eval),
    eval_date == eval,
    program_year <= lubridate::year(eval),
    # devt_age == devt,
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
  ) %>%
  group_by_at(c("program_year", "member", "department", group_by)) %>%
  summarise_at(vars(total_incurred, total_paid, count, open_count, close_count), sum, na.rm = TRUE) %>%
  ungroup() %>%
  full_join(exposure_data_hold, by = c("program_year", "member", "department")) %>%
  arrange(member) %>%
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

out <- hold %>% mutate(program_year = as.numeric(program_year)) %>%
  filter(program_year <= max_year) %>%
  mutate(program_year = as.character(program_year)) %>%
  mutate_if(is.numeric, function(x) ifelse(!is.finite(x), 0, x)) %>%
  mutate_if(is.numeric, round, digits = 3)

