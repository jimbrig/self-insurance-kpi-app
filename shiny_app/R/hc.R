hc <- function(summary_data, type = c("by_year", "by_eval"),
               eval, metric, devt_age, members, use_group_by, group_by,
               metric_choices, exposure_type, metric_descriptions) {

  summary_data <- summary_data %>%
    mutate(program_year = as.character(program_year)) %>%
    mutate_if(is.numeric, round, digits = 3)


  metric_label <- names(metric_choices)[match(metric, metric_choices)]

  exposure_label <- switch(exposure_type,
                           "payroll" = "Payroll ($00's)",
                           "miles" = "Miles (00's)")

  metric_desc <- metric_descriptions[match(metric_label, names(metric_descriptions))] %>%
    stringr::str_replace("Exposure", stringr::str_to_title(exposure_type))

  if (metric %in% c("total_incurred", "total_paid", "count", "open_count")) {
    yaxis_label <- metric_label
  } else {
    yaxis_label <- paste0(metric_label, ": ", metric_desc)
  }

  if (type == "by_year") {

    subtitle <- paste0("Evaluated as of ", format(eval, "%B %d, %Y"))

    if (!is.null(members)) {

      title <- paste0(
        metric_label, " - ",
        ifelse(length(members) < 4,
               knitr::combine_words(members),
               paste0(length(members), " Members Selected"))
      )

    } else {

      title <- metric_label

    }

    categories <- summary_data$program_year %>% unique() %>% sort()

    if (length(categories) == 1) categories <- list(categories)


    xtit <- "Program Year"


  } else {

    subtitle <- paste0(month(eval, label = TRUE, abbr = FALSE),
                       " Evaluations at ", devt_age, " Months of Maturity (Latest Evaluation of ",
                       format(eval, "%B %d, %Y"), ")")

    if (is.null(members)) {
      title <- "No Data to Display"
    } else {
      title <- paste0(
        metric_label, " - ",
        ifelse(length(members) < 4,
               knitr::combine_words(members),
               paste0(length(members), " Members Selected"))
      )
    }

    categories <- summary_data$program_year %>% unique() %>% sort()

    if (length(categories) == 1) categories <- list(categories)

    xtit <- "Program Year"

  }

  hold_chart <- highcharter::highchart() %>%
    hc_chart(
      type = "spline"
    ) %>%
    hc_title(
      text = title,
      style = list(fontWeight = "bold")
    ) %>%
    hc_subtitle(
      text = subtitle,
      style = list(fontWeight = "bold")
    ) %>%
    hc_xAxis(
      categories = categories,
      title = list(
        text = xtit,
        style = list(fontWeight = 'bold')
      )
    ) %>%
    hc_yAxis(
      title = list(
        text = yaxis_label,
        style = list(fontWeight = 'bold'),
        labels = list(format = '{value:.3f}')
      )
    ) %>%
    hc_legend(
      enabled = TRUE,
      align = 'center'
    ) %>%
    hc_tooltip(
      headerFormat = paste0("<b>", paste0(xtit, " "), "{point.x}:</b><br/>"),
      shared = TRUE,
      crosshairs = TRUE
    ) %>%
    hc_exporting(
      enabled = TRUE,
      filename = "Chart",
      formAttributes = list(target = '_blank'),
      buttons = hc_btn_options,
      sourceWidth = 1000,
      sourceHeight = 600
    ) %>%
    hc_plotOptions(
      series = list(
        dataLabels = list(
          enabled = TRUE,
          color = "#000",
          formatter = data_labels_dollar_formatter
        )
      ),
      spline = list(
        marker = list(
          enabled = TRUE
        )
      )
    )

  if (use_group_by) {

    out <- hold_chart

    cats <- summary_data %>% pull_unique(group_by) %>% as.character()

    if (length(cats) == 1) cats <- list(cats)

    for (i in seq_along(cats)) {

      dat <- summary_data %>%
        filter(.data[[group_by]] == cats[i]) %>%
        mutate(value = .data[[metric]]) %>%
        arrange(program_year)

      vals <- purrr::map(categories, function(x) {

        y_dat <- filter(dat, program_year == x)
        y_val <- y_dat[[metric]]

        if (nrow(y_dat) == 0 || is.na(y_val) || is.nan(y_val) || is.infinite(y_val)) {
          y_val <- 0
        }

        y_val

      })

      out <- out %>%
        hc_add_series(
          data = vals,
          name = cats[i],
          tooltip = list(pointFormat = '<span style="color:{point.color};font-weight:bold">\u25CF {series.name}:</span>{point.y:,.3f}<br/>')
        )
    }

  } else {

    out <- hold_chart %>%
      hc_add_series(
        data = summary_data[[metric]],
        name = metric_label,
        tooltip = list(pointFormat = '<span style="color:{point.color};font-weight:bold">\u25CF {series.name}:</span>{point.y:,.3f}<br/>')
      )

  }

  return(out)

}
