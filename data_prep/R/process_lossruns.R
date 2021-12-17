#' Process Lossrun Files
#'
#' Processes raw lossrun files for loading and extraction.
#'
#' @param raw_path path to directory housing raw lossruns.
#' @param processed_path path to directory to place processed lossruns.
#' @param force logical - force re-processing of and already processed raw files
#'  This will overwrite any currently processed lossruns in \code{processed_path}.
#'
#' @return invisibly returns the listing of processed files as a character vector.
#' @export
#' @importFrom fs dir_ls file_exists
#' @importFrom purrr map_chr walk2
#' @importFrom RDCOMClient COMCreate
#' @importFrom stringr str_detect
process_lossruns <- function(path,
                             keep_raw = TRUE,
                             raw_path = NULL,
                             processed_path,
                             force = FALSE) {

  # ensure RDCOMClient is loaded
  if (!isNamespaceLoaded("RDCOMClient")) {
    stop("Package RDCOMClient must be loaded before running this function.
         Run 'library(RDCOMCLient)'.")
  }

  # check/create dir
  if (missing(processed_path)) {
    processed_path <- fs::path_split(raw_path)[[1]] %>%
      stringr::str_replace("original", "working") %>%
      paste(collapse = "/") %>%
      fs::path()
  }

  if (!fs::dir_exists(processed_path)) fs::dir_create(processed_path,
                                                      recurse = TRUE)

  # list xls files that need to be converted to xlsx
  xls_files <- fs::dir_ls(raw_path, regexp = ".xls$", ignore.case = TRUE)

  # extract evaluation dates from file names
  eval_dates <- xls_files %>% purrr::map_chr(extract_date)

  # extract grouped vs ungrouped from file names
  groups <- xls_files %>% purrr::map_chr(function(x){
    if (stringr::str_detect(x, "NOT by OCC")) return("_ungrouped_old.xlsx")
    else return("_grouped_old.xlsx")
  })

  # specify new file names
  xlsx_files <- paste0(processed_path, "/", eval_dates, groups)

  # use VBA to convert to xlsx
  try({

    xls <- RDCOMClient::COMCreate("Excel.Application")

    purrr::walk2(xls_files, xlsx_files, function(x, y){

      if (!fs::file_exists(y) || force == TRUE) {
        message("Converting ", x, " to ", y)
        wb <- xls[["workbooks"]]$Open(normalizePath(x))
        wb$SaveAs(suppressWarnings(normalizePath(y)), 51) # 51 is for VBA
        wb$Close()
      } else {
        message("File ", y, " already exists.")
      }
    })

    xls$Quit()

  }, silent = TRUE)

  return(invisible(xlsx_files))

}
