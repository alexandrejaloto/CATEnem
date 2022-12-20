#' CH UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_CH_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' CH Server Functions
#'
#' @noRd
mod_CH_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$ui <- renderUI({
      tagList(
        h1('Ciências Humanas'),

        shinyjs::useShinyjs(),
        uiOutput(ns('botao_alternativas')),
        shinyjs::disabled(
          actionButton(
            ns('responder'),
            'Responder',
            onclick = 'document.getElementById(this.id).disabled = true'
          )
        )
      )
    })

    output$botao_alternativas <- renderUI({
      r$carrossel_itens[[df_CH$widget[it_select() + 1]]](
        df_cat_1_ch,
        it_select() + 1, # adicionamos 1 por conta da instrução
        ns
      )
    })

    # observe({
    #   # Lógica para habilitar o botão de responder
    #   if(!is.null(input$alternativas)) {
    #     if(input$alternativas != ''){
    #       shinyjs::enable('responder')
    #     }
    #   }
    # })
    #

  })
}

## To be copied in the UI
#

## To be copied in the server
#
