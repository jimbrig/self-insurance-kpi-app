server <- function(input, output, session) {

  callModule(header_buttons, "header_buttons", parent = session)

  callModule(coverage_tab, "wc", cov = "wc")

  callModule(coverage_tab, "al", cov = "al")


  shiny::showModal(
    shiny::modalDialog(
      title = icon_text("comments", "Welcome!"),
      easyClose = TRUE,
      size = "l",
      footer = tagList(
        actionButton("tour", "Tour App", icon = icon("bus")),
        modalButton("Dismiss", icon("door-open"))
      ),
      tags$iframe(src = "welcome.html", width = "100%", height = "600px",
                  scrolling = "auto", frameborder = 0)
    )
  )

  observeEvent(input$tour, {

    removeModal()

    rintrojs::introjs(
      session,
      # events = list(onbeforechange = readCallback("switchTabs")),
      options = list(
        # tooltipPosition = "auto",
        steps = list(
          list(
            element = "#tour_sidebar",
            intro = "Use the sidebar to navigate between Workers Compensation and
            Auto Liability.<br/><br/>You can collapse the sidebar by clicking the
            button to the right of the sidebar title in the header to increase
            screen display.",
            position = "right"
          ),

          list(
            element = "#wc-valboxes",
            intro = "Track relevant KPIs using these informative value boxes here.<br/><br/>
            Currently we display the following totals:<br/>
            - Total Incurred<br/>
            - Total Paid<br/>
            - Total Reported Counts (Grouped by Occurrence)<br/>
            - Total Exposures (Payroll or Miles Driven)</br>",
            hint = "HINT",
            position = "bottom-middle-aligned"
          ),
          list(
            element = "#wc-tabs",
            intro = "Navigate between tabs to view different charts and data tables.<br/><br/>
            'By Evaluation Date' displays metrics and data across historical evaluation
            dates depending on the user-defined Evaluation Date and Development Age
            inputs.<br/><br/>
            'By Program Year' only shows a single evaluation date across historical
            Program Years.",
            position = "bottom"
          ),
          list(
            element = "#wc-chart_by_eval",
            intro =
              "Charts are updated when the user interacts with any of the
            dynamic options or filters to the right.<br/><br/>
            The charts have many features including but not limited to:<br/><br/>
            - Download as PDF, Image, or CSV <br/>
            - Informative tooltips when hovering<br/>
            - Clickable legend to toggle display<br/>",
            position = "left"
          ),
          list(
            element = "#wc-options",
            intro = "Apply various options that affect the output displayed from
            here. Available options include:<br/><br/>
            <div class='text-center'>
            - Evaluation Date (Latest)<br/>
            - Development Age in Months of Maturity<br/>
            - Metric to Display<br/>
            - Exposure Base<br/>
            - Apply Groups Toggle<br/>
            - Group By Selection<br/>
            </div>",
            position = "botton"
          ),
          list(
            element = "#wc-eval_date",
            intro = "Select the (latest) evaluation date using this date calendar
            input.<br/><br/>
            Currently only April, August, and December evaluation dates are
            loaded.<br/><br/>
            Note that this input acts differently depending on whether you
            are viewing the 'By Evaluation Date' tabs or the 'By Program Year'
            tabs.<br/<br/>
            For more details see the information box below the respective charts.",
            position = "left"
          ),
          list(
            element = "#wc-development",
            intro = "Select the maturity in months (Development Age) you would
            like to compare across historical evaluation dates.<br/><br/>
            For example, with evaluation 12/31/19 and development age 12 the
            chart will display program years 2011-2019 as of 12 months maturity
            (December Evaluations).<br/><br/>
            Further, with evaluation 12/31/19 and 24 months maturity program years
            2011-2018 as of 24 months maturity will be compared. Note that this only
            affects the 'By Evaluation' Chart/Data Table."
          ),
          list(
            element = "#wc-metrics",
            intro = "Select the Metric you would like displayed on the chart.<br/>
            Selections include:<br/>
            - Incurred Loss Rate<br/>
            - Paid Loss Rate<br/>
            - Incurred Severity<br/>
            - Paid Severity<br/>
            - Frequency<br/>
            - Cumulative Closure Rate<br/>
            - Total Incurred Losses<br/>
            - Total Paid Losses<br/>
            - Reported Counts<br/>
            - Open Counts<br/><br/>
            Notes:<br/>
            - Incurred and Paid Losses are Unlimited and Net of Recoveries<br/>
            - Payroll used in Loss Rates are in hundreds (00's)<br/>
            - Payroll used in Frequencies are in millions (000,000's)<br/>
            - Counts are grouped by occurrence and exclude incident only occurrences.<br/>
            - Cumulative Closure Rate equals Closed Counts / Reported Counts<br/>"
          ),
          list(
            element = "#wc-expo_type",
            intro = "Select the Exposure Base used when calculating Incurred Loss Rate, Paid Loss Rate, and Frequency.<br/><br/>
            Choose from either Payroll or Miles Driven."
          ),
          list(
            element = "#wc-group_by_feature",
            intro = "Apply Groups allows the chart and data tabs to be displayed
            by different groupings.<br/>
            Charts and data can be grouped by Member, Department, Tenure, Claimant Age, Cause of Injury, and Claim Type.<br/>
            Metrics will be displayed separately by group.<br/>
            Try it out! Click the checkbox to 'Apply Groups'."
          ),
          list(element = "#wc-information",
               intro  = "Active Options & Filters displays all current selections and filtering for the chart and data tabs.<br/>
               The user can search for specific selections and filters that have been applied using the Search box.<br/>
               The user can also limit the number of entries displayed, and can hover over rows to view all entries within a row."
          )
        )
      )
    )

  })
}
