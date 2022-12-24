#' CN UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_CN_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' CN Server Functions
#'
#' @noRd
mod_CN_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # itens disponíveis
    rownames(df_CN) <- df_CN$cod_item
    itens_disponiveis <- df_CN[!grepl('instrucao$', df_CN$cod_item),]

    output$ui <- renderUI({
      tagList(
        h5('Ciências da Natureza'),
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
      r$carrossel_itens[[df_CN$widget[it_select() + 1]]](
        df_CN,
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

      if(is.null(r$CN$aplicados)) return(0)

      next_item(
        mod = r$CN,
        df = df_CN,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$CN$aplicados)){
        r$CN <- cria_r_cat(
          mod = r$CN,
          df = df_CN
        )
      } else {

        print(it_select())

        r$CN <- atualiza_r_cat(
          mod = r$CN,
          it_select = it_select(),
          input = input$alternativas,
          df = df_CN,
          modelo_cat = modelo_CN
        )

        r$CN$fim <- fim_cat(
          # criterios
          rule = list(
            fixed = 20,
            tempo_limite = .2
          ),
          current = list(
            applied = length(r$CN$aplicados),
            hist_resp_time = r$CN$hist_resp_time
          )
        )

        if(r$CN$fim$stop){

          r <- r_fim(
            r = r,
            area = 'CN',
            modelo_cat = modelo_CN
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
