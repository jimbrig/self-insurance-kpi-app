if (!requireNamespace("RInno")) {
    message("Installing RInno...")
    require(pak)
    pak::pak("ficonsulting/RInno")
}

library(RInno)
require(fs)
require(here)
require(gh)
require(rmarkdown)

if (!system("where.exe ISCC") == 0) {
    RInno::install_inno()
}

root <- here::here()
app_dir <- fs::path(root, "shiny_app")
app_temp_dir <- fs::path(root, "build_temp")
app_out_dir <- fs::path(root, "build")

fs::dir_create(app_temp_dir)

fs::dir_copy(app_dir, app_temp_dir, overwrite = TRUE)
fs::dir_delete(fs::path(app_temp_dir, "rsconnect"))

old <- getwd()
setwd(app_temp_dir)

RInno::create_app(
    app_name = "KPITracker",
    app_dir = getwd(),
    app_port = 1984,
    dir_out = "installer",
    pkgs = c(
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
        "qs"
    ),
    pkgs_path = "bin",
    repo = "https://cran.rstudio.com",
    app_repo_url = "https://github.com/jimbrig/self-insurance-kpi-app",
    auth_token = Sys.getenv("GITHUB_API_TOKEN"),
    user_browser = "electron",
    Pandoc_version = rmarkdown::pandoc_version(),
    Rtools_version = "4.2",
    overwrite = TRUE,
    force_nativefier = TRUE
)

RInno::compile_iss()

setwd(old)

fs::file_copy(
    fs::path(app_temp_dir, "installer", "setup_KPITracker.exe"),
    fs::path(app_out_dir, "installer")
)

# include_R = TRUE,
# include_Pandoc = TRUE,
# include_Chrome = FALSE,
# include_Rtools = TRUE,
# R_version = paste0(">=", R.version$major,
# ".", R.version$minor),
