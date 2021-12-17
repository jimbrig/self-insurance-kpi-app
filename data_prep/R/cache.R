#' Write Cache
#'
#' Quick caching utility write function.
#'
#' @param x object to cache
#' @param name name to store object with
#' @param cache_dir path to cache directory
#' @param overwrite logical (default = TRUE)
#'
#' @return x
#' @export
#'
#' @importFrom fs dir_exists dir_create path
#' @importFrom qs qsave
#'
#' @examples
#' mydata <- mtcars
#' write_cache(mydata) # will save to 'cache/mydata'.
#' write_cache(mydata, "mydata-v2", cache_dir = "data/temp") # will save to 'data/temp/mydata-v2'
write_cache <- function(x,
                        name = NULL,
                        cache_dir = "cache",
                        overwrite = TRUE) {

  if (!fs::dir_exists(cache_dir)) fs::dir_create(cache_dir)
  if (is.null(name)) name <- deparse(substitute(x))
  qs_file <- fs::path(cache_dir, name)
  qs::qsave(x, qs_file)
  message("Object ", name, " has been cached at '", qs_file, "'.")
  return(invisible(x))

}

#' Read Cache
#'
#' Quick caching utility read function.
#'
#' @param name name of object to read in.
#' @param cache_dir path to cache directory.
#'
#' @return invisibly attaches object to parent global environment
#' @export
#' @importFrom fs path file_exists
#' @importFrom fst read_fst
read_cache <- function(x,
                       name = NULL,
                       cache_dir = "cache") {

  if (is.null(name)) name <- deparse(substitute(x))
  qs_file <- fs::path(cache_dir, name)
  if (!fs::file_exists(qs_file)) {
    stop("File not found in ", cache_dir)
  }
  if (fs::file_exists(qs_file)) out <- qs::qread(qs_file)
  assign(name, out, envir = .GlobalEnv)
  return(invisible())

}
