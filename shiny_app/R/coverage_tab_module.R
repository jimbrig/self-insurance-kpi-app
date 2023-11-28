coverage_tab_ui <- function(id) {

  ns <- shiny::NS(id)

  loss_data <- loss_data %>%
    filter(coverage == toupper(id))

  itext <- switch(id,
                  "wc" = icon_text("briefcase", "Workers Compensation"),
                  "al" = icon_text("car", "Automobile Liability"))

  tabItem(
    tabName = ns(id),
    div(
      fluidRow(
        id = ns("valboxes"),
        valueBoxOutput(ns("valbox1"), 3),
        valueBoxOutput(ns("valbox2"), 3),
        valueBoxOutput(ns("valbox3"), 3),
        valueBoxOutput(ns("valbox4"), 3)
      )
    ),
    fluidRow(
      column(
        9,
        fluidRow(
          tabBox(
            id = ns("tabs"),
            width = 12,
            title = itext,


            tabPanel(
              title = "Chart by Evaluation Date",
              icon = icon("line-chart"),
              value = ns("chart_by_eval_tab"),
              fluidRow(
                column(
                  12,

                  div(
                    style = "display: inline; align: pull-left",

                    actionButton(ns("chart_features_1"),
                                 label = "View Chart Features",
                                 icon = icon("info"))
                  ),

                  highcharter::highchartOutput(
                    ns("chart_by_eval"),
                    height = 600
                  ) %>%
                    shinycssloaders::withSpinner()
                )
              )
            ),

            tabPanel(
              title = "Data by Evaluation Date",
              icon = icon("table"),
              value = ns("table_by_eval_tab"),
              fluidRow(
                column(
                  width = 12,

                  fluidRow(
                    column(
                     12,
                     div(
                       style = "display: inline; align: pull-left",

                       actionButton(ns("table_features_1"),
                                    label = "View Table Features",
                                    icon = icon("info"))
                     )
                    )
                  ),

                  hr(),

                  div(
                    style = "overflow-x: auto;",
                    DT::dataTableOutput(ns("table_by_eval")) %>%
                      shinycssloaders::withSpinner()
                  )
                )
              )
            ),

            tabPanel(
              title = "Chart by Program Year",
              icon = icon("line-chart"),
              value = ns("chart_by_year_tab"),
              fluidRow(
                column(
                  12,

                  div(
                    style = "display: inline; align: pull-left",

                    actionButton(ns("chart_features_2"),
                                 label = "View Chart Features",
                                 icon = icon("info"))
                  ),

                  highcharter::highchartOutput(
                    ns("chart_by_year"),
                    height = 600
                  ) %>%
                    shinycssloaders::withSpinner()
                )
              )
            ),

            tabPanel(
              title = "Data by Program Year",
              icon = icon("table"),
              value = ns("table_by_year_tab"),
              fluidRow(
                column(
                  width = 12,

                  fluidRow(
                    column(
                      12,
                      div(
                        style = "display: inline; align: pull-left",

                        actionButton(ns("table_features_2"),
                                     label = "View Table Features",
                                     icon = icon("info"))
                      )
                    )
                  ),

                  hr(),

                  div(
                    style = "overflow-x: auto;",
                    DT::dataTableOutput(ns("table_by_year")) %>%
                      shinycssloaders::withSpinner()
                  )
                )
              )
            )
          )
        ),

        fluidRow(
          tabBox(
            id = ns("information"),
            title = icon_text("info", " Information:"),
            width = 12,
            tabPanel(
              title = "Active Options & Filters",
              icon = icon("filter"),
              DT::dataTableOutput(ns("active_filters")) %>%
                shinycssloaders::withSpinner()
            )
          )
        )
      ),

      column(
        3,
        fluidRow(
          tabBox(
            id = ns("options"),
            title = icon_text("cogs", "Settings"),
            width = 12,
            # side = "right",

            tabPanel(
              title = icon_text("wrench", " Options"),
              value = ns("options_tabset"),
              div(
                class = "text-center",

                actionButton(
                  ns("reset_defaults1"),
                  label = "Reset Defaults",
                  icon = icon("refresh")
                ),

                br(),
                br(),

                div(
                  id = ns("opts"),

                  shinyWidgets::airDatepickerInput(
                    ns("eval_date"),
                    label = icon_text("calendar", "Select Evaluation:"),
                    value = "2019-12-31",
                    multiple = FALSE,
                    autoClose = TRUE,
                    view = "months",
                    minView = "months",
                    dateFormat = "MM yyyy",
                    monthsField = "months",
                    update_on = "close",
                    width = "100%",
                    maxDate = "2019-12-31",
                    minDate = "2011-04-30",
                    # inline = TRUE,
                    # clearButton = TRUE,
                    # todayButton = "2019-12-01",
                    # toggleSelected = FALSE
                  ),

                  br(),

                  div(
                    id = ns("development"),

                    sliderTextInput(
                      inputId = ns("devt_age"),
                      label = icon_text("clock", "Select Development Age:"),
                      choices = loss_data %>% filter(month(eval_date) == 12) %>%
                        pull_unique("devt_age"),
                      post = " Months",
                      grid = TRUE,
                      width = "100%"
                    )
                  ),

                  br(),

                  div(
                    id = ns("metrics"),
                    shinyWidgets::prettyRadioButtons(
                      ns("metric"),
                      label = icon_text("calculator", "Select Metric:"),
                      choices = metric_choices,
                      icon = icon("check"),
                      animation = "jelly",
                      width = "100%"
                    )
                  ),

                  br(),

                  div(
                    id = ns("expo_type"),
                    shinyWidgets::radioGroupButtons(
                      inputId = ns("exposure_type"),
                      label = icon_text("life-ring", "Select Exposure Base:"),
                      choiceNames = c(icon_text("dollar", " Payroll"),
                                      icon_text("road", " Miles Driven")),
                      choiceValues = c("payroll", "miles"),
                      selected = ifelse(id == "wc", "payroll", "miles"),
                      justified = TRUE
                    )
                  ),

                  br(),

                  div(
                    id = ns("group_by_feature"),
                    shiny::checkboxInput(
                      ns("use_group_by"),
                      label = tags$strong("Apply Groups?"),
                      value = FALSE,
                      width = "100%"
                    )
                  ),

                  br(),

                  shinyWidgets::radioGroupButtons(
                    ns("group_by"),
                    label = icon_text("cubes", " Group by:"),
                    choices = c("Member" = "member",
                                "Department" = "department",
                                "Tenure" = "tenure_group",
                                "Claimant Age" = "claimant_age_group",
                                "Cause of Injury" = "cause",
                                "Claim Type" = "claim_type"),
                    direction = "vertical",
                    justified = TRUE,
                    checkIcon = list(
                      yes = icon("check-square"),
                      no <- icon("square-xmark")
                    ),
                    width = "100%"
                  ) %>% shinyjs::hidden()

                )
              )
            ),

            tabPanel(
              id = ns("filters"),
              title = icon_text("filter", "Filters"),
              div(
                class = "text-center",

                actionButton(
                  ns("reset_defaults2"),
                  label = "Reset Defaults",
                  icon = icon("refresh")
                ),

                br(),
                br(),

                picker(
                  ns("member"),
                  label = icon_text("address-card" , "Select Member:"),
                  choices = loss_data %>% pull_unique("member"),
                  multiple = TRUE,
                  selected = pull_unique(loss_data, "member"),
                  width = "100%",
                  choice_options = list(
                    subtext = paste0(
                      "$",
                      loss_data %>%
                        pull_unique("member") %>%
                        purrr::map_chr(function(x) {
                          loss_data %>%
                            filter(eval_date == max(loss_data$eval_date)) %>%
                            group_by(member) %>%
                            summarise(inc = sum(total_incurred, na.rm = TRUE)) %>%
                            ungroup() %>%
                            filter(member == x) %>%
                            pull(inc) %>%
                            prettyNum(
                              big.mark = ",",
                              digits <- 1
                            ) %>%
                            as.character()
                        }),
                      " Incurred"
                    )
                  )
                ),

                br(),

                picker(
                  ns("department"),
                  label = icon_text("building", "Select Department:"),
                  choices = loss_data %>% pull_unique("department"),
                  multiple = TRUE,
                  selected = loss_data %>% pull_unique("department"),
                  width = "100%",
                  choice_options = list(
                    subtext = paste0(
                      "$",
                      loss_data %>%
                        pull_unique("department") %>%
                        purrr::map_chr(function(x) {
                          loss_data %>%
                            filter(eval_date == max(loss_data$eval_date)) %>%
                            group_by(department) %>%
                            summarise(inc = sum(total_incurred, na.rm = TRUE)) %>%
                            ungroup() %>%
                            filter(department == x) %>%
                            pull(inc) %>%
                            prettyNum(
                              big.mark = ",",
                              digits <- 1
                            ) %>%
                            as.character()
                        }),
                      " Incurred"
                    )
                  )
                ),

                br(),

                picker(
                  ns("incurred_group"),
                  label = icon_text("money-bill", " Select Claim Size - $ Incurred:"),
                  choices = levels(loss_data$incurred_group),
                  multiple = TRUE,
                  selected = levels(loss_data$incurred_group),
                  width = "100%"
                ),

                br(),

                picker(
                  ns("report_lag_group"),
                  label = icon_text("clock", "Select Report Lag:"),
                  choices = levels(loss_data$report_lag_group),
                  multiple = TRUE,
                  selected = levels(loss_data$report_lag_group),
                  width = "100%"
                ),

                br(),

                picker(
                  ns("driver_age_group"),
                  label = icon_text("user", "Select Driver Age:"),
                  choices = levels(loss_data$driver_age_group),
                  multiple = TRUE,
                  selected = levels(loss_data$driver_age_group),
                  width = "100%"
                ) %>% shinyjs::hidden(),

                br(),

                airDatepickerInput(
                  ns("loss_date"),
                  label = icon_text("calendar", "Select Loss Date Range:"),
                  range = TRUE,
                  view = "years",
                  clearButton = TRUE,
                  todayButton = TRUE,
                  update_on = "close",
                  value = c(beginning_of_month(min(loss_data$loss_date, na.rm = TRUE)),
                            end_of_month(max(loss_data$loss_date, na.rm = TRUE))),
                  width = "100%"
                ),

                br(),

                numericRangeInput(
                  ns("incurred_limits"),
                  icon_text("dollar", "Select Per Claim Incurred Range:"),
                  value = ceiling(loss_data$total_incurred),
                  width = "100%"
                ),

                br(),

                div(

                  id = ns("additional_filters"),

                  picker(
                    ns("cause"),
                    label = icon_text("medkit", "Select Cause of Injury:"),
                    choices = loss_data %>% pull_unique("cause"),
                    multiple = TRUE,
                    selected = loss_data %>% pull_unique("cause"),
                    width = "100%"
                  ),

                  br(),

                  picker(
                    ns("day_of_week"),
                    label = icon_text("calendar", "Select Day of Week:"),
                    choices = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
                    multiple = TRUE,
                    selected = loss_data %>% pull_unique("day_of_week"),
                    width = "100%"
                  ),

                  br(),

                  picker(
                    ns("claim_type"),
                    label = icon_text("paperclip", "Select Claim Type:"),
                    choices = loss_data %>% pull_unique("claim_type"),
                    multiple = TRUE,
                    selected = loss_data %>% pull_unique("claim_type"),
                    width = "100%"
                  ),

                  br(),

                  picker(
                    ns("claimant_state"),
                    label = icon_text("map", "Select Claimant State:"),
                    choices = loss_data %>% pull_unique("claimant_state"),
                    multiple = TRUE,
                    selected = loss_data %>% pull_unique("claimant_state"),
                    width = "100%"
                  ),

                  br(),

                  picker(
                    ns("loss_state"),
                    label = icon_text("map", "Select Loss State:"),
                    choices = loss_data %>% pull_unique("loss_state"),
                    multiple = TRUE,
                    selected = loss_data %>% pull_unique("loss_state"),
                    width = "100%"
                  )
                ) %>% shinyjs::hidden(),

                br(),

                actionButton(
                  ns("more_filters"),
                  label = "More Filters",
                  icon = icon("arrow-circle-down")
                ),

                actionButton(
                  ns("less_filters"),
                  label = "Less Filters",
                  icon = icon("arrow-circle-up")
                ) %>% shinyjs::hidden()
              )
            )
          )
        )
      )
    )
  )
}

coverage_tab <- function(input, output, session, cov) {

  loss_data <- loss_data %>%
    filter(coverage == toupper(cov))

  # if (tolower(cov) == "wc") {
  #   exposure_data <- filter(exposure_data, member != "Jake's, Inc.")
  #   loss_data <- filter(loss_data, member != "Jake's, Inc.")
  # }

  exposure_type <- reactive({
    input$exposure_type
  })

  observe({

    if (tolower(cov) == "al") {
    updateRadioGroupButtons(session = session, inputId = "group_by",
                            choices = c("Member" = "member",
                                        "Department" = "department",
                                        "Driver Age" = "driver_age_group",
                                        "Claimant Age" = "claimant_age_group",
                                        "Cause of Injury" = "cause",
                                        "Claim Type" = "claim_type"))
    }

    if (is.null(input$eval_date) || input$eval_date == 0 || !(lubridate::month(input$eval_date) %in% c(4, 8, 12))) {

      updateAirDateInput(session = session,
                         inputId = "eval_date",
                         value = "2019-12-31")

      showNotification("Evaluation Date reset to December 31, 2019",
                       duration = 5,
                       closeButton = TRUE,
                       type = "error")

      # on.exit(removeNotification(id), add = TRUE)


    }
  })

  shiny::observe({
    if (is.null(input$loss_date)) {

      shinyWidgets::updateAirDateInput(session = session,
                         inputId = "loss_date",
                         value = c(
                           beginning_of_month(min(loss_data$loss_date, na.rm = TRUE)),
                           end_of_month(max(loss_data$loss_date, na.rm = TRUE))
                         ))

      showNotification("Invalid Loss Dates selected.. Reset to defaults.",
                       duration = 5,
                       closeButton = TRUE,
                       type = "error")

      # on.exit(removeNotification(id), add = TRUE)


    }
  })

  eval <- reactive({
    end_of_month(input$eval_date)
  })


  observe({
    if (tolower(cov) == "al") {
      shinyjs::show("driver_age_group")
    }
  })

  observeEvent(input$use_group_by, {

    if (input$use_group_by == TRUE) {
      shinyjs::show("group_by")
    } else {
      shinyjs::hide("group_by")
    }

  })

  observeEvent(input$more_filters, {
    shinyjs::toggle("additional_filters", anim = TRUE)
    shinyjs::toggle("more_filters")
    shinyjs::toggle("less_filters")
  })

  observeEvent(input$less_filters, {
    shinyjs::toggle("additional_filters", anim = TRUE)
    shinyjs::toggle("more_filters")
    shinyjs::toggle("less_filters")
  })

  observeEvent(input$eval_date, {

    ages <- loss_data %>%
      filter(month(eval_date) == month(eval())) %>%
      pull_unique("devt_age")

    updateSliderTextInput(session = session,
                          inputId = "devt_age",
                          choices = ages,
                          selected = lubridate::month(eval()))
  })

  observeEvent(input$tabs, {

    if (input$tabs %in% c("wc-table_by_eval_tab", "wc-chart_by_eval_tab",
                          "al-table_by_eval_tab", "al-chart_by_eval_tab")) {
      shinyjs::show("devt_age")
    } else {
      shinyjs::hide("devt_age")
    }

  })

  observeEvent(list(input$chart_features_1, input$chart_features_2), {

    shiny::showModal(
      shiny::modalDialog(
        title = icon_text("chart-line", "Chart Features Overview:"),
        easyClose = TRUE,
        size = "l",
        tags$iframe(src = "chart_features.html",
                    width = "100%",
                    height = "500px",
                    scrolling = "auto",
                    frameborder = 0)
      )
    )

  }, ignoreInit = TRUE)

  observeEvent(list(input$table_features_1, input$table_features_2), {

    shiny::showModal(
      shiny::modalDialog(
        title = icon_text("table", "Table Features Overview:"),
        easyClose = TRUE,
        size = "l",
        tags$iframe(src = "table_features.html",
                    width = "100%",
                    height = "630px",
                    scrolling = "auto",
                    frameborder = 0)
      )
    )

  }, ignoreInit = TRUE)

  current_filters <- reactive({

    tibble::tibble(
      "Label" = c(
        "Coverage",
        "Evaluation Date",
        "Development Age",
        "Grouping By",
        "Exposure Base",
        "Members",
        "Departments",
        "Incurred Min/Max",
        "Loss Date Min/Max",
        "Cause",
        "Day of Week",
        "Claim Type",
        "Claimant State",
        "Loss State",
        "Claim Size",
        "Report Lag",
        "Driver Age"
      ),
      "Value" = c(
        ifelse(cov == "wc", "Worker's Compensation", "Auto Liability"),
        format(eval(), "%B %d, %Y"),
        paste0(input$devt_age, " Months of Maturity"),
        ifelse(input$use_group_by == TRUE, toproper(input$group_by), "Totals"),
        stringr::str_to_title(exposure_type()),
        paste0(length(input$member), "/", length(pull_unique(loss_data, "member")),
               " Members Selected: ", knitr::combine_words(input$member)),
        paste0(length(input$department), "/", length(pull_unique(loss_data, "department")),
               " Departments Selected: ", knitr::combine_words(input$department)),
        paste0(
          paste0("Min: ",
                 prettyNum(
                   input$incurred_limits[1], digits = 1, big.mark = ","
                 )
          ),
          paste0("; Max: ",
                 prettyNum(
                   input$incurred_limits[2], digits = 1, big.mark = ","
                 )
          )
        ),
        paste0("Min: ", format(input$loss_date[1], "%B %d, %Y"),
               "; Max: ", format(input$loss_date[2], "%B %d, %Y")),

        paste0(length(input$cause), "/", length(pull_unique(loss_data, "cause")),
               " Causes Selected: ", knitr::combine_words(input$cause)),
        paste0(length(input$day_of_week), "/", length(pull_unique(loss_data, "day_of_week")),
               " Days of the Week Selected: ", knitr::combine_words(input$day_of_week)),
        paste0(length(input$claim_type), "/", length(pull_unique(loss_data, "claim_type")),
               " Claim Types Selected: ", knitr::combine_words(input$claim_type)),
        paste0(length(input$claimant_state), "/", length(pull_unique(loss_data, "claimant_state")),
               " Claimant States Selected: ",knitr::combine_words(input$claimant_state)),
        paste0(length(input$loss_state), "/", length(pull_unique(loss_data, "loss_state")),
               " Loss States Selected: ", knitr::combine_words(input$loss_state)),
        paste0(length(input$incurred_group), "/", length(pull_unique(loss_data, "incurred_group")),
               " Claim Size Groups Selected: ",knitr::combine_words(input$incurred_group)),
        paste0(length(input$report_lag_group), "/", length(pull_unique(loss_data, "report_lag_group")),
               " Report Lag Groups Selected: ",knitr::combine_words(input$report_lag_group)),
        ifelse(
          tolower(cov) == "wc", "N/A",
          paste0(length(input$driver_age_group), "/", length(pull_unique(loss_data, "driver_age_group")),
               " Driver Age Groups Selected: ", knitr::combine_words(input$driver_age_group))
        )
      )
    )

  })



  output$active_filters <- renderDT({
    current_filters() %>%
      datatable(# fillContainer = TRUE,
        rownames = FALSE,
        caption = "Hover over a row to view all contents.",
        options = list(
          # paging = FALSE,
          processing = TRUE,
          # dom = "t",
          pageLength = nrow(current_filters()),
          columnDefs = list(
            list(
              className = "dt-left",
              targets = "_all",
              render = JS(
                "function(data, type, row, meta) {",
                "return type === 'display' && data.length > 140 ?",
                "'<span title=\"' + data + '\">' + data.substr(0, 140) + '...</span>' : data;",
                "}"
              )
            )
          )
        )
      )
  })

  observeEvent({
    list(input$reset_defaults1,
         input$reset_defaults2)
  }, {

    default_expo_type <- switch(tolower(cov),
                                "wc" = "payroll",
                                "al" = "miles")

    shiny::showNotification("All Options and Filters Reset to Defaults.",
                            duration = 5, type = "message")

    updateAirDateInput(session = session, inputId = "eval_date", value = "2019-12-31")
    updateSliderTextInput(session = session, inputId = "devt_age", selected = 12)
    updateRadioGroupButtons(session = session, inputId = "exposure_type",
                            selected = default_expo_type)
    updateAirDateInput(session = session, inputId = "loss_date",
                       value = c(
                         beginning_of_month(min(loss_data$loss_date, na.rm = TRUE)),
                         end_of_month(max(loss_data$loss_date, na.rm = TRUE))
                       ))
    updateNumericRangeInput(session = session, inputId = "incurred_limits",
                            label = icon_text("dollar", "Select Per Claim Incurred Range:"),
                            value = ceiling(loss_data$total_incurred))

    # shinyjs::reset("devt_age")
    shinyjs::reset("metrics")
    shinyjs::reset("use_group_by")
    shinyjs::reset("group_by")
    shinyjs::reset("member")
    shinyjs::reset("department")
    shinyjs::reset("incurred_group")
    shinyjs::reset("report_lag_group")
    shinyjs::reset("driver_age_group")
    # shinyjs::reset("loss_date")
    # shinyjs::reset("incurred_limits")
    shinyjs::reset("cause")
    shinyjs::reset("day_of_week")
    shinyjs::reset("claim_type")
    shinyjs::reset("claimant_state")
    shinyjs::reset("loss_state")
    # shinyjs::reset("expo_type")
    # shinyjs::reset("filters")


  }, ignoreInit = TRUE)

  summary_by_year <- reactive({

    create_summary_by_year(
      loss_data, exposure_data, eval = eval(), exposure_type = exposure_type(),
      members = input$member,
      departments = input$department,
      incurred_min_max = input$incurred_limits,
      loss_date_min_max = input$loss_date,
      causes = input$cause,
      days = input$day_of_week,
      claim_types = input$claim_type,
      claimant_states = input$claimant_state,
      loss_states = input$loss_state,
      incurred_groups = input$incurred_group,
      report_lag_groups = input$report_lag_group,
      use_group_by = input$use_group_by,
      group_by = input$group_by,
      driver_age_groups = input$driver_age_group
    )

  })



  summary_by_eval <- reactive({

    create_summary_by_eval(
      loss_data, exposure_data, eval = eval(), devt = input$devt_age,
      exposure_type = exposure_type(),
      members = input$member,
      departments = input$department,
      incurred_min_max = input$incurred_limits,
      loss_date_min_max = input$loss_date,
      causes = input$cause,
      days = input$day_of_week,
      claim_types = input$claim_type,
      claimant_states = input$claimant_state,
      loss_states = input$loss_state,
      incurred_groups = input$incurred_group,
      report_lag_groups = input$report_lag_group,
      use_group_by = input$use_group_by,
      group_by = input$group_by,
      driver_age_groups = input$driver_age_group
    )

  })



  output$valbox1 <- renderValueBox({

    val <- sum(summary_by_year()$total_incurred, na.rm = TRUE) %>%
      display_num()

    valueBox(
      value =  paste0("$", val),
      subtitle = toupper("Total Incurred"),
      icon = tags$i(
        class = "fa fa-money-bill",
        style = "color: #ffffff; padding-right: 30px"
      ),
      color = "navy",
      width = 3
    )
  })

  output$valbox2 <- renderValueBox({

    val <- sum(summary_by_year()$total_paid, na.rm = TRUE) %>%
      display_num()

    valueBox(
      value =  paste0("$", val),
      subtitle = toupper("Total Paid"),
      icon = tags$i(
        class = "fas fa-cash-register",
        style = "color: #ffffff; padding-right: 30px"
      ),
      color = "navy",
      width = 3
    )
  })

  output$valbox3 <- renderValueBox({

    val <- sum(summary_by_year()$count, na.rm = TRUE) %>%
      display_num()

    valueBox(
      value =  val,
      subtitle = toupper("Reported Counts"),
      icon = tags$i(
        class = "fa fa-envelope",
        style = "color: #ffffff; padding-right: 30px"
      ),
      color = "navy",
      width = 3
    )
  })

  output$valbox4 <- renderValueBox({

    i <- switch(exposure_type(),
                "payroll" = "fa fa-dollar",
                "miles" = "fa fa-road")

    expo_prefix <- switch(
      exposure_type(),
      "payroll" = "$",
      "miles" = ""
    )

    val <- sum(summary_by_year()$expo, na.rm = TRUE) %>%
      display_num()

    valueBox(
      value = paste0(expo_prefix, val),
      subtitle = toupper(exposure_type()),
      icon = tags$i(
        class = i,
        style = "color: #ffffff; padding-right: 30px"
      ),
      color = "navy",
      width = 3
    )
  })

  output$table_by_year <- DT::renderDataTable({

    dt(summary_by_year(), type = "by_year", cov = cov, eval = eval(),
       exposure_type = exposure_type(), use_group_by = input$use_group_by,
       group_by = input$group_by, devt_age = input$devt_age)

  }, server = FALSE)

  output$table_by_eval <- DT::renderDataTable({

    dt(summary_by_eval(), type = "by_eval", cov = cov, eval = eval(),
       exposure_type = exposure_type(), use_group_by = input$use_group_by,
       group_by = input$group_by, devt_age = input$devt_age)

  }, server = FALSE)

  output$chart_by_year <- highcharter::renderHighchart({

    hc(summary_by_year(), type = "by_year",
       eval = eval(), devt_age = input$devt_age, metric = input$metric,
       members = input$member, use_group_by = input$use_group_by,
       group_by = input$group_by, metric_choices = metric_choices,
       exposure_type = exposure_type(), metric_descriptions = metric_descriptions)

  })

  output$chart_by_eval <- highcharter::renderHighchart({

    hc(summary_by_eval(), type = "by_eval",
       eval = eval(), devt_age = input$devt_age, metric = input$metric,
       members = input$member, use_group_by = input$use_group_by,
       group_by = input$group_by, metric_choices = metric_choices,
       exposure_type = exposure_type(), metric_descriptions = metric_descriptions)

  })


}
