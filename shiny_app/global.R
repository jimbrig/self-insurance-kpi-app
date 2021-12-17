
#  ------------------------------------------------------------------------
#
# Title : Global Script
#    By : Jimmy Briggs
#  Date : 2020-11-12
#
#  ------------------------------------------------------------------------

# Library Packages --------------------------------------------------------
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(shinycssloaders)
library(purrr)
library(lubridate)
library(tibble)
library(dplyr)
library(highcharter)
library(stringr)
library(rintrojs)
library(DT)
library(knitr)
library(rmarkdown)
library(qs)

# Source Functions --------------------------------------------------------
# purrr::walk(fs::dir_ls("R"), source)
source("R/utils.R")
source("R/coverage_tab_module.R")
source("R/header_buttons_module.R")
source("R/shinytools.R")

# Global Options ----------------------------------------------------------
options(shiny.autoload.r = TRUE)
options(scipen = 999)
options(dplyr.summarise.inform = FALSE)
hcoptslang <- getOption("highcharter.lang")
hcoptslang$thousandsSep <- ","
options(highcharter.lang = hcoptslang)
rm(hcoptslang)

# Data --------------------------------------------------------------------
loss_data <- qs::qread("data/loss_data_scrubbed") %>% filter(program_year != "2020")
exposure_data <- qs::qread("data/exposures_scrubbed") %>% filter(program_year != "2020")

# Markdown ----------------------------------------------------------------
# render_outdated()

# Constants ---------------------------------------------------------------
latest_eval <- max(loss_data$eval_date)

contacts <- c(
  contact_item("Jimmy Briggs", "Developer", "678-491-4856", "jimmy.briggs@tychobra.com")
)

metric_choices <- c(
  "Incurred Loss Rate" = "incurred_loss_rate",
  "Paid Loss Rate" = "paid_loss_rate",
  "Incurred Severity" = "incurred_severity",
  "Paid Severity" = "paid_severity",
  "Frequency" = "frequency",
  "Cumulative Closure Rate" = "cum_closure_rate",
  "Total Incurred Losses" = "total_incurred",
  "Total Paid Losses" = "total_paid",
  "Reported Counts" = "count",
  "Open Counts" = "open_count"
)

metric_descriptions <- c(
  "Incurred Loss Rate" = "Incurred Loss/Exposure (00's)",
  "Paid Loss Rate" = "Paid Loss/Exposure (00's)",
  "Incurred Severity" = "Incurred Loss/Reported Counts",
  "Paid Severity" = "Paid Loss/Reported Counts",
  "Frequency" = "Reported Counts/Exposure (000,000's)",
  "Cumulative Closure Rate" = "Closed Counts/Total Reported Counts",
  "Total Incurred Losses" = "Total Incurred Loss",
  "Total Paid Losses" = "Total Paid Loss",
  "Reported Counts" = "Total Reported Counts (Grouped by Occurrence)",
  "Open Counts" = "Total Reported Open Counts (Grouped by Occurrence)"
)

hc_btn_options <- list(
  contextButton = list(
    text = "Download",
    menuItems = list(
      list(
        text = "Export to PDF",
        onclick = JS(
          "function () { this.exportChart({
          type: 'application/pdf'
          }); }"
        )
      ),
      list(
        text = "Export to Image",
        onclick = JS(
          "function () {
          this.exportChart(null, {
          chart: {
          backgroundColor: '#FFFFFF'
          },
          });
          }"
        )
      ),
      list(
        textKey = 'downloadCSV',
        onclick = JS("function () {
                     this.downloadCSV();
                     }")
      )
    )
  )
)

data_labels_dollar_formatter <- JS("function() {
                                   var y_val = this.y

                                   if (y_val > 1000000) {
                                   y_val = y_val / 1000000
                                   y_val = Math.round(y_val * 10) / 10
                                   y_val = y_val + 'M'
                                   } else if (y_val > 1000) {
                                   y_val = y_val / 1000
                                   y_val = Math.round(y_val * 10) / 10
                                   y_val = y_val + 'K'
                                   } else if (y_val > 1.1) {
                                   y_val = y_val
                                   y_val = Math.round(y_val * 1000) / 1000
                                   y_val = y_val
                                   } else {
                                   y_val = Math.round(y_val * 1000) / 1000
                                   }

                                   return y_val
        }")

tooltip_formatter <- JS("function() {
  //console.log('this', this.points[0])
  var points = this.points

  var ys = []
  var y = null
  ys = points.map(function(el) {
    var out = null
    y = el.y
    if (y > 1000000) {
      out = Math.round(y / 100000) / 10
      out = out.toLocaleString('en-US', {minimumFractionDigits: 1, maximumFractionDigits: 1})
      out = out + 'M'
    } else if (y > 1000) {
      out = Math.round(y / 100) / 10
      out = out.toLocaleString('en-US', {minimumFractionDigits: 1, maximumFractionDigits: 1})
      out = out + 'K'
    } else if (y > 2) {
      out = y.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0})
    } else {
      out = y.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})
    }

    return out
  })
  //console.log('ys2', ys)

  var html_out = '<b>Program Year ' + this.x.name + ':</b><br/>'
  var last_metric = ''

  var i;
  for (i = 0; i < points.length; i++) {

    if (points[i].series.userOptions.my_metric !== last_metric) {
      html_out += '<b>' + this.points[i].series.userOptions.my_metric + ' :<b><br/>'
      last_metric = this.points[i].series.userOptions.my_metric
    }

    html_out += '<span style=\"color:' + points[i].color + '\">\u25CF ' + points[i].series.userOptions.my_group + ': </span>' + ys[i] + '<br/>'
  }

  return html_out
}")
