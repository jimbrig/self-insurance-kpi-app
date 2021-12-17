library(qs)

source("data_prep/R/cache.R")
source("data_prep/R/utils.R")

cache_dir <- "data_prep/cache"

read_cache(kpi_loss_data, cache_dir = cache_dir)

# IDs
occ_ids <- pull_unique(kpi_loss_data, "occurrence_number")
occ_nums <- c(1:length(occ_ids))
occ_ids_scrubbed <- paste0("Occurrence-", occ_nums)
occ_tbl <- tibble::tibble(
  occurrence_number = occ_ids,
  occurrence_number_scrubbed = occ_ids_scrubbed
)

# Member
members <- pull_unique(kpi_loss_data, "member")
members_scrubbed <- paste0("Member ", c(1:length(members)))
member_tbl <- tibble::tibble(
  member = members,
  member_scrubbed = members_scrubbed
)

loss_data_scrubbed <- list(kpi_loss_data, occ_tbl, member_tbl) %>%
  purrr::reduce(dplyr::left_join) %>%
  dplyr::mutate(
    occurrence_number = occurrence_number_scrubbed,
    member = member_scrubbed
  ) %>%
  dplyr::select(-contains("_scrubbed"))

write_cache(loss_data_scrubbed, cache_dir = cache_dir)
write_cache(loss_data_scrubbed, cache_dir = "shiny_app/data")

# exposures ---------------------------------------------------------------
read_cache(kpi_exposure_data, cache_dir = cache_dir)

exposures_scrubbed <- dplyr::left_join(kpi_exposure_data, member_tbl) %>%
  dplyr::mutate(member = member_scrubbed) %>%
  dplyr::select(-contains("scrubbed"))

write_cache(exposures_scrubbed, cache_dir = cache_dir)
write_cache(exposures_scrubbed, cache_dir = "shiny_app/data")

