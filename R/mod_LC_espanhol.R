#' LC_espanhol UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_LC_espanhol_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' LC_espanhol Server Functions
#'
#' @noRd
mod_LC_espanhol_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # itens disponíveis
    rownames(df_LC) <- df_LC$cod_item
    itens_disponiveis <- df_LC[!grepl('instrucao$', df_LC$cod_item),]
    itens_disponiveis <- subset (itens_disponiveis, is.na(itens_disponiveis$fator) | itens_disponiveis$fator != 'i')

    output$ui <- renderUI({
      tagList(
        h5('Linguagens e Códigos (inglês)'),
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
      r$carrossel_itens[[df_LC$widget[it_select() + 1]]](
        df_LC,
        it_select() + 1, # adicionamos 1 por conta da instrução
        ns
      )
    })

    observe({
      # Lógica para habilitar o botão de responder
      if(!is.null(input$alternativas)) {
        if(input$alternativas != ''){
          shinyjs::enable('responder')
        }
      }
    })

    # selecionar o item
    it_select <- reactive({

      if(is.null(r$LC$aplicados)) return(0)

      next_item(
        mod = r$LC,
        df = df_LC,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$LC$aplicados)){
        r$LC <- cria_r_cat(
          mod = r$LC,
          df = df_LC
        )
      } else {

        print(it_select())

        r$LC <- atualiza_r_cat(
          mod = r$LC,
          it_select = it_select(),
          input = input$alternativas,
          df = df_LC,
          modelo_cat = modelo_LC
        )

        r$LC$fim <- fim_cat(
          # criterios
          rule = list(
            fixed = 20,
            tempo_limite = .2
          ),
          current = list(
            applied = length(r$LC$aplicados),
            hist_resp_time = r$LC$hist_resp_time
          )
        )

        if(r$LC$fim$stop){

          r <- r_fim(
            r = r,
            area = 'LC',
            modelo_cat = modelo_LC
          )

          r$grafico <- cria_grafico(
            info = r
          )

          output$ui <- renderUI({
            mod_devolutiva_ui("devolutiva_1")
          })

        }
      }
    })

  })
}

## To be copied in the UI
#

## To be copied in the server
#
