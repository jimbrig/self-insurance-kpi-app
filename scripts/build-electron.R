# pak::pak("ficonsulting/RInno")
require(RInno)

# pak::pak("ficonsulting/RInno")
library(RInno)

if (!system("where.exe ISCC") == 0) { RInno::install_inno() }

RInno::create_app(app_name = "KPI-Tracker",
                  app_dir = "shiny_app",
                  dir_out = "installer",
                  pkgs = c("shiny",
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
                           "qs"),
                  # include_R = TRUE,
                  R_version = "3.6.3",
                  overwrite = TRUE
)

RInno::compile_iss()


RInno::create_app(app_name = "KPI-Tracker",
                  app_dir = "shiny_app",
                  dir_out = "installer",
                  pkgs = c("shiny",
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
                           "qs"),
                  include_R = TRUE
                  )

RInno::compile_iss()

