#' Extract Date
#'
#' Extracts dates from a character string with format "mm-dd-yyyy" or "mm/dd/yyyy".
#'
#' @param string character string
#'
#' @return date object
#' @export
#'
#' @examples
#' extract_date("data-raw/lossrun-as-of-2019-01-31.xlsx")
#' @importFrom lubridate mdy
#' @importFrom stringr str_extract_all
extract_date <- function(string) {

  paste0(
    unlist(
      stringr::str_extract_all(
        string,
        "[0-9]{1,2}[-./][0-9]{1,2}[-./][0-9]{2,4}"
      ),
      recursive = TRUE
    ),
    collapse = ""
  ) %>%
    lubridate::mdy() %>%
    as.character()

}

#' To Proper
#'
#' @param string string to manipulate on
#' @param replace_underscores Logical: if \code{TRUE} replaces all underscores
#'   with specified \code{underscore_replacement} argument's value.
#' @param underscore_replacement Character: if argument \code{replace_underscores}
#'  equals \code{TRUE}, will replace all "_"'s with specified string.
#' @param return_as How should the string be returned? Options are:
#'   \itemize{
#'   \item{"titlecase"}: Applies \code{stringr::str_to_title}.
#'   \item{"uppercase"}: Applies \code{toupper}.
#'   \item{"lowercase"}: Applied \code{tolower}.
#'   \item{"asis"}: No manipulation. Returns as is.
#'   }
#'
#' @seealso \code{\link[stringr]{str_replace}}.
#'
#' @return "Proper" string
#' @export
#'
#' @examples
#' s <- "variable_a is awesome"
#' toproper(s)
#'
#' @importFrom stringr str_replace_all str_to_title
toproper <- function(string,
                     replace_underscores = TRUE,
                     underscore_replacement = " ",
                     return_as = c("titlecase", "uppercase", "lowercase", "asis"),
                     uppers = c("Tpa")) {

  return_as = match.arg(return_as, several.ok = FALSE)

  if (replace_underscores) {
    string <- stringr::str_replace_all(string, pattern = "_", replacement = underscore_replacement)
  }

  if (return_as == "asis") return(string)

  hold <- switch(
    return_as,
    titlecase = stringr::str_to_title(string),
    uppercase = toupper(string),
    lowercase = tolower(string)
  )

  stringr::str_replace_all(hold, uppers, toupper(uppers))

}



#' Extract numbers from a string
#'
#' @param string String to pull numbers from
#'
#' @return String of numbers
#' @export
#' @importFrom stringr str_extract
extract_num <- function(string){
  stringr::str_extract(string, "\\-*\\d+\\.*\\d*")
}

#' Pull Unique Values from a dataframe
#'
#' @param df Dataframe
#' @param var Quoted named of variable
#'
#' @return Character vector of unique, sorted values from specified column
#' @export
pull_unique <- function(df, var){
  df[[var]] %>%
    unique() %>%
    sort()
}

#' Coalesce Join
#'
#' @param x x
#' @param y y
#' @param by by
#' @param suffix suffix
#' @param join join type
#' @param ... passed to dplyr join function
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom dplyr union coalesce bind_cols
#' @importFrom purrr map_dfc
coalesce_join <- function(x,
                          y,
                          by = NULL,
                          suffix = c(".x", ".y"),
                          join = dplyr::full_join,
                          ...) {

  joined <- join(y, x, by = by, suffix = suffix, ...)

  # names of desired output
  cols <- dplyr::union(names(x), names(y))

  to_coalesce <- names(joined)[!names(joined) %in% cols]

  suffix_used <- suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]

  # remove suffixes and deduplicate
  to_coalesce <- unique(
    substr(
      to_coalesce,
      1,
      nchar(to_coalesce) - nchar(suffix_used)
    )
  )

  coalesced <- purrr::map_dfc(
    to_coalesce, ~ dplyr::coalesce(joined[[paste0(.x, suffix[1])]],
                                   joined[[paste0(.x, suffix[2])]])
  )

  names(coalesced) <- to_coalesce

  dplyr::bind_cols(joined, coalesced)[cols]

}

end_of_month <- function(date) {

  # stopifnot(lubridate::is.Date(date))

  lubridate::ceiling_date(date, unit = "months") - 1

}

beginning_of_month <- function(date) {

  # stopifnot(lubridate::is.Date(date))

  lubridate::floor_date(date, unit = "months")

}

derive_calcs <- function(dat) {

  dat %>%
    mutate(
      incurred_loss_rate = (total_incurred / expo) * 100,
      paid_loss_rate = (total_paid / expo) * 100,
      incurred_severity = total_incurred / count,
      paid_severity = total_paid / count,
      frequency = (count / expo) * 100000,
      cum_closure_rate = close_count / count
    )

}

render_outdated <- function(dir = "www") {

  rmds <- as.character(fs::dir_ls(dir, glob = "*.Rmd"))
  htmls <- as.character(fs::path_ext_set(rmds, "html"))

  purrr::walk2(rmds, htmls, function(rmd, html) {

    if (!file.exists(html) || file.mtime(html) < file.mtime(rmd)) {
      message("HTML file not detected, knitting ", rmd)
      rmarkdown::render(rmd,  encoding = 'UTF-8')
    }

  })

}


display_num <- function(num) {
  div <- findInterval(
    abs(num),
    c(0, 1e3, 1e6, 1e9, 1e12)
  )
  paste(
    format(round(num / 10^(3*(div - 1)), 1), big.mark = ","),
    c("","K","M","B","T")[div]
  )
}
