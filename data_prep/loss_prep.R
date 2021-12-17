
#  ------------------------------------------------------------------------
#
# Title : Code to Prepare Data for the KPI Shiny App - Losses and Exposures
#    By : Jimmy Briggs
#  Date : 2020-04-09
#
#  ------------------------------------------------------------------------

# setup -------------------------------------------------------------------

# library packages
library(R.utils)
library(lubridate)
library(readxl)
library(janitor)
library(purrr)
library(tidyr)
library(forcats)
library(fs)
library(stringr)
library(writexl)
library(qs)
library(openxlsx)
library(dplyr)

# source functions
R.utils::sourceDirectory("data-prep/R", modifiedOnly = FALSE)



# backup raw data files ---------------------------------------------------
# network_files_info <- fs::dir_info(paths$raw_lossruns_network)
# stash("raw_lossrun_files_network",
#       depends_on = "network_files_info", {
#         network_files <- fs::path(paths$raw_lossruns_network) %>%
#           fs::dir_ls() %>%
#           backup_raw(dest_dir = paths$raw_lossruns)
#       })

# process loss run files --------------------------------------------------
# library(RDCOMClient)
# raw_files <- fs::dir_info(paths$raw_lossruns)
# stash("old_lossruns_processed",
#       depends_on = "raw_files", {
#         processed_files <- process_lossruns(paths$processed_lossruns)
#       })

# extract raw data from processed loss runs -------------------------------
# processed_files <- fs::dir_info(fs::path(paths$processed_lossruns))
# stash("old_data_raw",
#       depends_on = "processed_files", {
#         old_data_raw <- fs::dir_ls(fs::path(paths$processed_lossruns),
#                                    type = "file") %>%
#           purrr::map_dfr(extract_raw)
#       })

# clean extracted raw data ------------------------------------------------
stash("old_data_clean",
      depends_on = "old_data_raw", {
        old_data_clean <- old_data_raw %>% clean_data()
      })

# merge data with report working grouped data -----------------------------
working_data_grouped <- qs::qread("data-prep/data/working_data_grouped")

stash("kpi_loss_data_prelim",
      depends_on = c("old_data_clean", "working_data_grouped"), {
        kpi_loss_data_prelim <- merge_data(old_data_clean,
                                           working_data_grouped)
      })

# transform data ----------------------------------------------------------
stash("kpi_loss_data",
      depends_on = "kpi_loss_data_prelim", {
        kpi_loss_data <- transform_data(kpi_loss_data_prelim)
      })

write_cache(kpi_loss_data, cache_dir = "data-prep/cache")
saveRDS(kpi_loss_data, "shiny-app/data/kpi_loss_data.RDS", version = 2)

fs::dir_create("data-prep/outputs")
writexl::write_xlsx(kpi_loss_data, "data-prep/outputs/kpi_loss_data.xlsx")

