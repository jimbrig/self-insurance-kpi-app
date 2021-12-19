#' Contact Item
#'
#' Creates an item to be placed in a contact dropdownmenu.
#'
#' @param name Name
#' @param role Role
#' @param phone Phone
#' @param email Email
#'
#' @return contact menu item
#' @export
#' @importFrom shiny tagList icon
#' @importFrom htmltools tags a
contact_item <- function(name = "First Name, Last Name",
                         role = "Role",
                         phone = "###-###-####",
                         email = "first.last@oliverwyman.com"){

  shiny::tagList(
    htmltools::tags$li(htmltools::a(href = "#", shiny::h4(tags$b(name)), shiny::h5(tags$i(role)))),
    htmltools::tags$li(htmltools::a(shiny::icon("envelope"), href = paste0("mailto:", email), email)),
    htmltools::tags$li(htmltools::a(shiny::icon("phone"), href = "#", phone)),
    htmltools::tags$hr()
  )

}

#' Creates a dropdown menu specific for contacts
#'
#' @param ... contact items to put into dropdown
#'
#' @return menu
#' @export
#' @importFrom shiny tags div
contact_menu <- function(...){

  items <- c(list(...))

  shiny::tags$li(
    class = "dropdown",
    shiny::tags$a(
      href = "#",
      class = "dropdown-toggle",
      `data-toggle` = "dropdown",
      shiny::div(
        shiny::tags$i(
          class = "fa fa-phone"
        ),
        "Contact",
        style = "display: inline"
      ),
      shiny::tags$ul(
        class = "dropdown-menu",
        items)
    )
  )
}

#' Insert Logo
#'
#' @param file file
#' @param style style
#' @param width width
#' @param ref ref
#'
#' @return tag
#' @export
#' @importFrom shiny tags img
insert_logo <- function(file,
                        style = "background-color: #FFF; width: 100%; height: 100%;",
                        width = NULL,
                        ref = "#"){

  shiny::tags$div(
    style = style,
    shiny::tags$a(
      shiny::img(
        src = file,
        width = width
      ),
      href = ref
    )
  )

}


#' Icon Text
#'
#' Creates an HTML div containing the icon and text.
#'
#' @param icon fontawesome icon
#' @param text text
#'
#' @return HTML div
#' @export
#'
#' @examples
#' icon_text("table", "Table")
#'
#' @importFrom shiny icon tagList
icon_text <- function(icon, text) {

  i <- shiny::icon(icon)
  t <- paste0(" ", text)

  shiny::tagList(div(i, t))

}

#' Fluid Column - Shiny fluidRow + Column
#'
#' @param ... elements to include within the flucol
#' @param width width
#' @param offset offset
#'
#' @return A column wrapped in fluidRow
#' @export
#'
#' @examples
#' propertyAllocation::flucol(12, 0, shiny::h5("HEY"))
#' @importFrom shiny fluidRow column
flucol <- function(..., width = 12, offset = 0) {

  if (!is.numeric(width) || (width < 1) || (width > 12))
    stop("column width must be between 1 and 12")

  shiny::fluidRow(
    shiny::column(
      width = width,
      offset = offset,
      ...
    )
  )
}

#' Download Button without opening up new window in browser when downloaded
#'
#' @param outputId
#' @param label
#' @param class
#' @param icon
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
downloadButtonEdit <- function (outputId, label = "Download", class = NULL, icon = NULL, ...)
{
  aTag <-
    tags$a(
      id = outputId,
      class = paste("btn btn-default shiny-download-link",
                    class),
      href = "",
      target = NA, # NA here instead of _blank
      download = NA,
      icon(icon),
      label,
      ...
    )
}

#' @title Create a numeric input control with icon(s)
#'
#' @description Extend form controls by adding text or icons before,
#'  after, or on both sides of a classic \code{numericInput}.
#'
#' @inheritParams shiny::numericInput
#' @param icon An \code{icon} or a \code{list}, containing \code{icon}s
#'  or text, to be displayed on the right or left of the numeric input.
#' @param size Size of the input, default to \code{NULL}, can
#'  be \code{"sm"} (small) or \code{"lg"} (large).
#'
#' @return A numeric input control that can be added to a UI definition.
#' @export
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools tags validateCssUnit
#'
#' @example examples/numericInputIcon.R
numericInputIcon <- function(inputId, label, value,
                             min = NULL, max = NULL, step = NULL,
                             icon = NULL, size = NULL, width = NULL) {
  value <- shiny::restoreInput(id = inputId, default = value)
  addons <- validate_addon(icon)
  tags$div(
    class = "form-group shiny-input-container",
    if (!is.null(label)) {
      tags$label(label, `for` = inputId)
    },
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
    tags$div(
      class = "input-group",
      class = validate_size(size),
      addons$left, tags$input(
        id = inputId,
        type = "number",
        class = "form-control",
        value = value,
        min = min,
        max = max,
        step = step
      ), addons$right
    )
  )
}

picker <- function(id, label, choices, selected = choices, multiple = TRUE, count_threshold = 3, choice_options = NULL, ...) {

  shinyWidgets::pickerInput(
    id,
    label = label,
    choices = choices,
    selected = selected,
    multiple = multiple,
    choicesOpt = choice_options,
    options = shinyWidgets::pickerOptions(
      actionsBox = TRUE,
      liveSearch = TRUE,
      selectedTextFormat = paste0("count > ", count_threshold),
      countSelectedText = "{0} / {1} Selected",
      liveSearchPlaceholder = "Search...",
      virtualScroll = 100,
      dropupAuto = FALSE,
      dropdownAlignRight = TRUE
    ),
    ...
  )

}


