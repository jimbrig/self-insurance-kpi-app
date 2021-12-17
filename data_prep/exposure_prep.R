
#  ------------------------------------------------------------------------
#
# Title : Exposure Data Preparation
#    By : Jimmy Briggs
#  Date : 2020-04-19
#
#  ------------------------------------------------------------------------

library(fs)
library(purrr)
library(openxlsx)
library(readxl)
library(writexl)
library(dplyr)
library(janitor)
library(tidyr)
library(stringr)
library(lubridate)
library(R.utils)

# source functions
R.utils::sourceDirectory("data-prep/R", modifiedOnly = FALSE)

exposure_file <- fs::path("data-prep/data/exposures/exposures-working.xlsx")

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

exposure_data_wc <- readxl::read_excel(
  exposure_file,
  "payroll"
) %>%
  janitor::clean_names() %>%
  purrr::set_names(c("member", extract_num(names(.)[2:ncol(.)]))) %>%
  tidyr::pivot_longer(
    cols = 2:ncol(.),
    names_to = "year",
    values_to = "payroll"
  ) %>%
  filter(!(stringr::str_trim(member) %in% invalid_members)) #,
# payroll > 0)

exposure_data_al <- readxl::read_excel(
  exposure_file,
  "miles"
) %>%
  janitor::clean_names() %>%
  purrr::set_names(c("member", extract_num(names(.)[2:ncol(.)]))) %>%
  tidyr::pivot_longer(
    cols = 2:ncol(.),
    names_to = "year",
    values_to = "miles"
  ) %>%
  filter(!(stringr::str_trim(member) %in% invalid_members))

# load loss data
read_cache(kpi_loss_data, cache_dir = "data-prep/cache")
wc_data <- kpi_loss_data %>% dplyr::filter(coverage == "WC")
al_data <- kpi_loss_data %>% dplyr::filter(coverage == "AL")

member_table_wc <- tibble::tibble(
  member_wc_expos = pull_unique(exposure_data_wc, "member"),
  member_wc_losses = pull_unique(wc_data, "member")
)

member_table_al <- tibble::tibble(
  member_al_expos = pull_unique(exposure_data_al, "member"),
  member_al_losses = pull_unique(al_data, "member")
)

exposure_data_al <- left_join(
  exposure_data_al,
  rename(member_table_al, member = member_al_expos)
) %>%
  select(member = member_al_losses, year, miles)

kpi_exposure_data <- exposure_data_al %>%
  left_join(exposure_data_wc, by = c("member", "year")) %>%
  rename(program_year = year)

write_cache(kpi_exposure_data, cache_dir = "data-prep/cache")

# fs::file_copy("cache/kpi_exposure_data", "inst/kpi_app/data/kpi_exposure_data", overwrite = TRUE)
# saveRDS(kpi_exposure_data, "inst/kpi_app/data/exposure_data.RDS", version = 2)


# payroll adjustments -----------------------------------------------------


# per adam make ace, ginsbergs, and wabash 2019 = 2018
new_exposure_file <- fs::path("data-prep/data/exposures/new_payroll_adjusted.xlsx")

dept_map <- openxlsx::read.xlsx(
  "data-prep/data/exposures/exposure_department_mapping.xlsx",
  1, 1, cols = c(1:2)
)

members_map <- openxlsx::read.xlsx("data-prep/data/exposures/members_map_for_payroll.xlsx")




# Members by PY sheet
sheets <- c(2011:2019) %>% as.character()

raw_data <- purrr::map_dfr(
  sheets, function(x) {
    openxlsx::read.xlsx(new_exposure_file, x) %>%
      mutate_all(as.character)
  }
) %>%
  janitor::clean_names()

tidy_data <- raw_data %>%
  tidyr::pivot_longer(cols = 5:ncol(raw_data),
                      names_to = "member",
                      values_to = "payroll") %>%
  mutate_at(vars(py, payroll), as.numeric) %>%
  left_join(dept_map, by = "description") %>%
  left_join(members_map, by = "member") %>%
  filter(!is.na(member_mapped)) %>%
  select(program_year = py,
         member = member_mapped,
         department,
         state,
         class_code = code,
         class_description = description,
         payroll)

read_cache(kpi_exposure_data, cache_dir = "data-prep/cache")

kpi_exposure_data <- kpi_exposure_data %>% rename(payroll_old = payroll) %>%
  mutate(program_year = as.numeric(program_year)) %>%
  filter(program_year < 2020)

miles <- kpi_exposure_data %>% select(member, program_year, miles) %>%
  mutate(department = "Drivers",
         miles = ifelse(member == "Tapia Enterprises" & program_year %in% c(2014:2016),
                        11600000, miles))

new_exposures <- tidy_data %>%
  group_by(member, program_year, department) %>%
  summarise(payroll = sum(payroll, na.rm = TRUE)) %>%
  ungroup() %>%
  full_join(miles) %>%
  mutate_at(vars(miles, payroll), tidyr::replace_na, 0) %>%
  mutate(department = stringr::str_trim(department))

write_cache(new_exposures, cache_dir = "data-prep/cache")

saveRDS(new_exposures, "shiny-app/data/kpi_exposure_data.RDS", version = 2)

writexl::write_xlsx(new_exposures, "data-prep/outputs/updated_exposures.xlsx")
