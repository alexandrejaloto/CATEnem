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

    # itens disponíveis
    rownames(df_CH) <- df_CH$cod_item
    itens_disponiveis <- df_CH[!grepl('instrucao$', df_CH$cod_item),]

    output$ui <- renderUI({
      tagList(
        h5('Ciências Humanas'),
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
        df_CH,
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

      if(is.null(r$CH$aplicados)) return(0)

      next_item(
        mod = r$CH,
        df = df_CH,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$CH$aplicados)){
        r$CH <- cria_r_cat(
          mod = r$CH,
          df = df_CH
        )
      } else {

        print(it_select())

        r$CH <- atualiza_r_cat(
          mod = r$CH,
          it_select = it_select(),
          input = input$alternativas,
          df = df_CH,
          modelo_cat = modelo_CH
        )

        r$CH$fim <- fim_cat(
          # criterios
          current = list(
            applied = length(r$CH$aplicados),
            hist_resp_time = r$CH$hist_resp_time
          )
        )

        if(r$CH$fim$stop){

          r <- r_fim(
            r = r,
            area = 'CH',
            modelo_cat = modelo_CH
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
