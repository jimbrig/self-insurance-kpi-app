#' Backup Raw
#'
#' @param remotes remote directories to copy
#' @param dest_dir destination directory
#' @param multiprocess logical
#'
#' @return remotes
#' @export
#'
#' @importFrom fs dir_exists dir_create
#' @importFrom purrr map
#' @importFrom syncr has_rsync syncr
backup_raw <- function(remotes, dest_dir = "data-raw") {

  if (!fs::dir_exists(dest_dir)) fs::dir_create(dest_dir)
  if (!syncr::has_rsync()) stop("This function utilizes the CLI library 'syncr'.\n
                               Please install following directions from
                               https://github.com/AlanBarber/jbh/wiki/Installing-RSync-on-Windows")
  purrr::map(remotes, syncr::syncr, dest = dest_dir)
  return(remotes)
}
