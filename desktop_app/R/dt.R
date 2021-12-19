dt <- function(summary_data,
               type = c("by_year", "by_eval"),
               cov,
               eval,
               exposure_type,
               use_group_by,
               group_by,
               devt_age) {

  # browser()

  if (use_group_by == FALSE) group_by <- NULL

  summary_data <- summary_data %>%
    mutate(program_year = as.numeric(program_year)) %>%
    filter(total_incurred + total_paid + count > 0 | expo > 0)

  if (use_group_by) {
    summary_data <- summary_data %>%
      arrange(!! rlang::sym(group_by), program_year)
  }

  round_cols <- c(
    "total_incurred",
    "total_paid",
    "incurred_severity",
    "paid_severity"
  )

  cnt_cols <- c(
    "count",
    "close_count",
    "open_count"
  )

  rate_cols <- c(
    "incurred_loss_rate",
    "paid_loss_rate",
    "frequency",
    "cum_closure_rate"
  )

  if (type == "by_year") {

    cap <- switch(
      tolower(cov),
      "wc" = paste0("Workers Compensation as of ",
                    format(eval, "%B %d, %Y")),
      "al" = paste0("Automobile Liability as of ",
                    format(eval, "%B %d, %Y"))
    )
  }

  if (type == "by_eval") {

    cap <- switch(
      tolower(cov),
      "wc" = paste0("Workers Compensation - ", as.character(month(eval, label = TRUE, abbr = FALSE)),
                    " Evaluations - ", devt_age, " Months Maturity"),
      "al" = paste0("Automobile Liability - ", as.character(month(eval, label = TRUE, abbr = FALSE)),
                    " Evaluations - ", devt_age, " Months Maturity")
    )

  }

  expo_prefix <- switch(
    exposure_type,
    "payroll" = "$",
    "miles" = ""
  )

  expo_label <- stringr::str_to_title(exposure_type)

  colnames <- c(
    "Program Year",
    toproper(group_by),
    "Incurred",
    "Paid",
    "Counts",
    "Closed",
    "Open",
    expo_label,
    "Incurred Rate",
    "Paid Rate",
    "Incurred Severity",
    "Paid Severity",
    "Frequency",
    "Closure Rate"
  )

  if (use_group_by == FALSE) colnames <- setdiff(colnames, toproper(group_by))

  DT::datatable(
    summary_data,
    rownames = FALSE,
    colnames = colnames,
    caption = cap,
    extensions = "Buttons",
    filter = "top",
    options = list(
      dom = "BRfrltpi",
      columnDefs = list(
        list(
          className = "dt-center",
          targets = "_all",
          render = JS(
            "function(data, type, row, meta) {",
            "return type === 'display' && data.length > 20 ?",
            "'<span title=\"' + data + '\">' + data.substr(0, 20) + '...</span>' : data;",
            "}"
          )
        )
      ),
      buttons = list(
        'copy', 'print',
        list(
          extend = "collection",
          buttons = c('csv', 'excel', 'pdf'),
          text = "Download",
          title = paste0("Loss-Table-Summary-", toupper(cov), "-", Sys.Date())
        ),
        list(
          extend = 'colvis',
          text = 'Edit Displayed Columns'
        )
      )
    )
  ) %>%
    formatCurrency(
      "expo",
      digits = 0,
      currency = expo_prefix
    ) %>%
    formatCurrency(
      round_cols,
      digits = 0
    ) %>%
    formatRound(
      rate_cols,
      digits = 3
    ) %>%
    formatCurrency(
      cnt_cols,
      currency = "",
      digits = 0
    )

}
