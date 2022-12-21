#' CH_aut UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_CH_aut_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' CH_aut Server Functions
#'
#' @noRd
mod_CH_aut_server <- function(id, r){
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

      if(is.null(r$aplicados)) return(0)

      next_item(
        mod = r,
        df = df_CH,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$aplicados)){
        r <- cria_r_cat(
          mod = r,
          df = df_CH
        )
      } else {

        r <- atualiza_r_cat(
          mod = r,
          it_select = it_select(),
          input = input$alternativas,
          df = df_CH,
          modelo_cat = modelo_CH
        )

        r$fim <- fim_cat(
          # criterios
          rule = list(
            fixed = 1,
            tempo_limite = .5
          ),
          current = list(
            applied = length(r$aplicados),
            hist_resp_time = r$hist_resp_time
          )
        )

        if(r$fim$stop){

          r <- r_fim(r, 'CH')

          # r$theta_enem <- transform_nota(
          #   nota_01 = r$theta,
          #   area = 'CH'
          # )
          #
          # r$theta_hist <- transform_nota(
          #   nota_01 = r$theta_hist,
          #   area = 'CH'
          # )
          #
          # r$padrao <- r$padrao
          #
          # r$aplicados <- r$aplicados
          #
          # r$tempo <- r$hist_resp_time
          #
          # r$grafico <- cria_grafico(
          #   info = r
          # )

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
