



header <- shinydashboard::dashboardHeader(
  title = "KPI Tracker",
  .list = header_buttons_ui("header_buttons", contacts = contacts)
)

sidebar <- shinydashboard::dashboardSidebar(withTags({
  div(
    style = "margin-bottom: 20px; margin-top: 15px",
    h5(
      "Client XYZ",
      br(),
      "KPI Tracking Dashboard",
      br(),
      paste0("Latest Evaluation: ", latest_eval),
      align = "center",
      style = "font-weight: bold; color: #ffffff;"
    ),
    hr()
  )
}),

div(id = "tour_sidebar",
    sidebarMenu(
      id = "sidebar",
      menuItem(
        "Workers Compensation",
        tabName = "wc",
        icon = icon("briefcase"),
        selected = TRUE
      ),
      menuItem(
        "Automobile Liability",
        tabName = "al",
        icon = icon("car")
      )
    )))

body <- shinydashboard::dashboardBody(
  shinyjs::useShinyjs(),
  shinyWidgets::useSweetAlert(),
  rintrojs::introjsUI(),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "introjs-theme.css"),
    shiny::tags$link(
      rel = "shortcut icon",
      href = "images/favicon.ico")
  ),
  tags$script(src = "custom.js"),
  tabItems(
    tabItem(
      tabName = "wc",
      coverage_tab_ui("wc")),
    tabItem(tabName = "al",
            coverage_tab_ui("al"))
  )
)

# Finalize ----------------------------------------------------------------
dashboardPage(header,
              sidebar,
              body,
              skin = "black",
              title = "KPIs")
