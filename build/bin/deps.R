pkgs <- c(
    "shiny",
    "shinydashboard",
    "shinyjs",
    "shinyWidgets",
    "shinycssloaders",
    "purrr",
    "lubridate",
    "tibble",
    "dplyr",
    "highcharter",
    "stringr",
    "rintrojs",
    "DT",
    "knitr",
    "rmarkdown",
    "config",
    "qs",
    "rlang",
    "htmltools",
    "forcats",
    "fs"
)

for (pkg in pkgs) {
    message(paste0("Checking package: ", pkg))
    if (!requireNamespace(pkg)) {
        message(paste0("Installing package: ", pkg))
        install.packages(pkg)
    }
}
